//
//  UserProfileDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/25.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class UserProfileDataSource: NSObject, UITableViewDataSource {
    
    fileprivate enum TableSection: Int, EnumEnumerable {
        case ProfileData
        case DogData
        case ReviewData
        case ReviewMore
    }
    
    enum Action {
        case none
        case reviewMore
    }
    
    private static let EACH_DOG_DISPLAY_ITEM_NUM: Int = 6
    
    private let tableView: UITableView
    private let tableDelegate: TableDelegate
    private var reviews: [Review] = []
    private let disposeBag: DisposeBag = DisposeBag()
    private var user: User
    private var isCompletedReviewPagination: Bool = false
    fileprivate let action: Variable<Action> = Variable(.none)
    private var userDogs: [Dog] = []
    private var reviewTotalCount: Int = 0
    
    var observeAction: Driver<Action> {
        return action.asDriver()
    }
    
    init(tableView: UITableView, user: User) {
        self.user = user
        self.tableView = tableView
        self.tableDelegate = TableDelegate(tableView: tableView)
        
        self.tableView.register(ProfileCell.NIB, forCellReuseIdentifier: ProfileCell.IDENTITY)
        self.tableView.register(ReviewCell.NIB, forCellReuseIdentifier: ReviewCell.IDENTITY)
        self.tableView.register(HorizontalItemCell.NIB, forCellReuseIdentifier: HorizontalItemCell.IDENTITY)
        
        self.tableView.estimatedRowHeight = 48
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.cases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSection(rawValue: section)! {
        case .ProfileData:
            return 1
        case .DogData:
            return UserProfileDataSource.EACH_DOG_DISPLAY_ITEM_NUM * userDogs.count
        case .ReviewData:
            return reviews.count
        case .ReviewMore:
            return isCompletedReviewPagination ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch TableSection(rawValue: section)! {
        case .ProfileData:
            return tableDelegate.generateSectionHeader(section: section, title: "プロフィール")
        case .DogData:
            return tableDelegate.generateSectionHeader(section: section, title: "飼っているワンちゃんについて")
        case .ReviewData:
            return tableDelegate.generateSectionHeader(section: section, title: "レビュー（\(reviewTotalCount)）", score: user.scoreAverage)
        case .ReviewMore:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableSection(rawValue: indexPath.section)! {
        case .ProfileData:
            let cell: ProfileCell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.IDENTITY, for: indexPath) as! ProfileCell
            cell.bind(user: user)
            return cell
        case .DogData:
            let currentIndex = indexPath.row % UserProfileDataSource.EACH_DOG_DISPLAY_ITEM_NUM
            let currentDog = userDogs[indexPath.row / UserProfileDataSource.EACH_DOG_DISPLAY_ITEM_NUM]
            switch currentIndex {
            case 0:
                let cell: HorizontalItemCell = tableView.dequeueReusableCell(withIdentifier: HorizontalItemCell.IDENTITY, for: indexPath) as! HorizontalItemCell
                cell.bind(data: HorizontalItemCell.DisplayData(title: "名前", value: currentDog.name))
                return cell
            case 1:
                let cell: HorizontalItemCell = tableView.dequeueReusableCell(withIdentifier: HorizontalItemCell.IDENTITY, for: indexPath) as! HorizontalItemCell
                let breedType = PublicAssetRepository.shared.dogBreedTypes.first(where: {
                    $0.value == currentDog.breed
                })!
                cell.bind(data: HorizontalItemCell.DisplayData(title: "犬種", value: breedType.label))
                return cell
            case 2:
                let cell: HorizontalItemCell = tableView.dequeueReusableCell(withIdentifier: HorizontalItemCell.IDENTITY, for: indexPath) as! HorizontalItemCell
                let gender = PublicAssetRepository.shared.dogGenderTypes.first(where: {
                    $0.value == currentDog.gender
                })!
                cell.bind(data: HorizontalItemCell.DisplayData(title: "性別", value: gender.label))
                return cell
            case 3:
                let cell: HorizontalItemCell = tableView.dequeueReusableCell(withIdentifier: HorizontalItemCell.IDENTITY, for: indexPath) as! HorizontalItemCell
                cell.bind(data: HorizontalItemCell.DisplayData(title: "年齢", value: String(currentDog.age)))
                return cell
            case 4:
                let cell: HorizontalItemCell = tableView.dequeueReusableCell(withIdentifier: HorizontalItemCell.IDENTITY, for: indexPath) as! HorizontalItemCell
                cell.bind(data: HorizontalItemCell.DisplayData(title: "去勢", value: currentDog.isCastrated ? "しています" : "していません"))
                return cell
            default:
                let cell = UITableViewCell()
                cell.backgroundColor = UIColor.backgroundColor()
                return cell
            }
        case .ReviewData:
            let cell: ReviewCell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.IDENTITY, for: indexPath) as! ReviewCell
            cell.bind(review: reviews[indexPath.row])
            return cell
        case .ReviewMore:
            let cell: UITableViewCell = tableDelegate.generateMoreReadCell()
            return cell
        }
    }
    
    func bind(user: User) {
        self.user = user
        self.tableView.reloadData()
    }
    
    func bind(reviews: Driver<[Review]>) {
        reviews.drive(onNext: { items in
            self.reviews.append(contentsOf: items)
            self.tableView.reloadData()
        })
        .addDisposableTo(disposeBag)
    }
    
    func bind(state: Driver<PaginationState>) {
        state.drive(onNext: { state in
            switch state {
            case .hasNext:
                break
            case .completed:
                self.isCompletedReviewPagination = true
                self.tableView.reloadData()
            }
        })
        .addDisposableTo(disposeBag)
    }
    
    func bind(dogs: Driver<[Dog]>) {
        dogs.drive(onNext: { dogs in
            self.userDogs = dogs
            self.tableView.reloadData()
        })
        .addDisposableTo(disposeBag)
    }
    
    func bind(reviewTotalCount: Driver<Int>) {
        reviewTotalCount.drive(onNext: { count in
            self.reviewTotalCount = count
            self.tableView.reloadData()
        }).addDisposableTo(disposeBag)
    }
}

extension UserProfileDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch TableSection(rawValue: section)! {
        case .ReviewMore:
            return CGFloat(0)
        default:
            return CGFloat(TableDelegate.SECTION_HEIGHT)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch TableSection(rawValue: indexPath.section)! {
        case .ProfileData:
            break
        case .DogData:
            break
        case .ReviewData:
            break
        case .ReviewMore:
            self.action.value = .reviewMore
        }
    }

}

