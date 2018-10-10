//
//  SitterDetailDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/22.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SitterDetailDataSource: NSObject, UITableViewDataSource {
    
    fileprivate enum TableSection: Int, EnumEnumerable {
        case HouseThumbnail
        case Tag
        case Service
        case Profile
        case Review
        case ReviewMore
        case Map
    }
    
    enum Action {
        case None
        case ReviewMore
        case Map
    }
    
    private let tableDelegate: SearchTableDelegate
    private let tableView: UITableView
    private let disposeBag: DisposeBag = DisposeBag()
    private var reviews: [Review] = []
    fileprivate var sitter: Sitter
    private var isCompletedReviewPagination: Bool = false
    fileprivate let action: Variable<Action> = Variable(.None)
    private let selectPhoto: Variable<Image?> = Variable(nil)
    private var sitterDogs: [Dog] = []
    private var reviewTotalCount: Int = 0
    
    var observeSelectPhoto: Driver<Image?> {
        return selectPhoto.asDriver()
    }
    
    var observeAction: Driver<Action> {
        return action.asDriver()
    }
    
    var selectPhotoDisposable: Disposable? = nil
    
    init(tableView: UITableView, sitter: Sitter) {
        self.sitter = sitter
        self.tableView = tableView
        self.tableDelegate = SearchTableDelegate(tableView: tableView)
        
        self.tableView.register(SitterHouseThumbnailCell.NIB, forCellReuseIdentifier: SitterHouseThumbnailCell.IDENTITY)
        self.tableView.register(SitterHouseTagCell.NIB, forCellReuseIdentifier: SitterHouseTagCell.IDENTITY)
        self.tableView.register(HorizontalItemCell.NIB, forCellReuseIdentifier: HorizontalItemCell.IDENTITY)
        self.tableView.register(SitterProfileCell.NIB, forCellReuseIdentifier: SitterProfileCell.IDENTITY)
        self.tableView.register(VerticalItemCell.NIB, forCellReuseIdentifier: VerticalItemCell.IDENTITY)
        self.tableView.register(ReviewCell.NIB, forCellReuseIdentifier: ReviewCell.IDENTITY)
        self.tableView.register(MapCell.NIB, forCellReuseIdentifier: MapCell.IDENTITY)
        
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
        case .HouseThumbnail:
            return 1
        case .Tag:
            return 1
        case .Service:
            return 4
        case .Profile:
            return 2
        case .Review:
            return reviews.count
        case .ReviewMore:
            return isCompletedReviewPagination ? 0 : 1
        case .Map:
            return sitter.address != nil ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch TableSection(rawValue: section)! {
        case .HouseThumbnail:
            return tableDelegate.generateSectionHeader(section: section, title: "ホストの家の写真")
        case .Tag:
            return tableDelegate.generateSectionHeader(section: section, title: "家について")
        case .Service:
            return tableDelegate.generateSectionHeader(section: section, title: "お世話の内容について")
        case .Profile:
            return tableDelegate.generateSectionHeader(section: section, title: "ホストプロフィール&メッセージ")
        case .Review:
            return tableDelegate.generateSectionHeader(section: section, title: "レビュー（\(reviewTotalCount)）", score: sitter.scoreAverage)
        case .ReviewMore:
            return nil
        case .Map:
            if self.sitter.address != nil {
                return tableDelegate.generateSectionHeader(section: section, title: "エリア")
            } else {
                return nil
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableSection(rawValue: indexPath.section)! {
        case .HouseThumbnail:
            let cell: SitterHouseThumbnailCell = tableView.dequeueReusableCell(withIdentifier: SitterHouseThumbnailCell.IDENTITY, for: indexPath) as! SitterHouseThumbnailCell

            cell.bind(images: Observable.just(sitter.interiorImages))
            
            selectPhotoDisposable?.dispose()
            selectPhotoDisposable = cell.observeSelectPhoto
                .asObservable()
                .skip(1)
                .bind(to: selectPhoto)
            return cell
        case .Tag:
            let cell: SitterHouseTagCell = tableView.dequeueReusableCell(withIdentifier: SitterHouseTagCell.IDENTITY, for: indexPath) as! SitterHouseTagCell
            cell.bind(sitter: sitter)
            return cell
        case .Service:
            let cell: HorizontalItemCell = tableView.dequeueReusableCell(withIdentifier: HorizontalItemCell.IDENTITY, for: indexPath) as! HorizontalItemCell
            
            switch indexPath.row {
            case 0:
                let keepingStyleLabel: String = PublicAssetRepository.shared.dogKeepingStyles
                    .first(where: { $0.value == sitter.dogKeepingStyle.rawValue })?.label ?? "未登録"
                cell.bind(data: HorizontalItemCell.DisplayData(title: "受け入れのスタイル", value: keepingStyleLabel))
                cell.withMiddleWidthBottomBorder()
            case 1:
                let walkingPolicyLabel: String = PublicAssetRepository.shared.walkingPolicies
                    .first(where: { $0.value == sitter.walkingPolicy.rawValue })?.label ?? "未登録"
                cell.bind(data: HorizontalItemCell.DisplayData(title: "散歩について", value: walkingPolicyLabel))
                cell.withMiddleWidthBottomBorder()
            case 2:
                let acceptableDogTypeLabel: String = sitter.acceptableDogTypes.map({ type in
                    PublicAssetRepository.shared.dogAttributes.first(where: { $0.value == type.rawValue })?.label ?? ""
                }).joined(separator: "\n")
                cell.bind(data: HorizontalItemCell.DisplayData(
                    title: "世話が可能な犬のタイプ",
                    value: acceptableDogTypeLabel.isEmpty ? "未登録" : acceptableDogTypeLabel))
                cell.withMiddleWidthBottomBorder()
            case 3:
                let unAcceptableDogTypeLabel: String = sitter.unacceptableDogTypes.map({ type in
                    PublicAssetRepository.shared.dogAttributes.first(where: { $0.value == type.rawValue })?.label ?? ""
                }).joined(separator: "\n")
                print(unAcceptableDogTypeLabel)
                cell.bind(data: HorizontalItemCell.DisplayData(
                    title: "受け入れられない犬",
                    value: unAcceptableDogTypeLabel.isEmpty ? "未登録" : unAcceptableDogTypeLabel))
                cell.withFullWidthBottomBorder()
            default:
                break
            }
            return cell
        case .Profile:
            if indexPath.row == 0 {
                let cell: SitterProfileCell = tableView.dequeueReusableCell(withIdentifier: SitterProfileCell.IDENTITY, for: indexPath) as! SitterProfileCell
                cell.bind(sitter: sitter)
                return cell
            } else if indexPath.row == 1 {
                let cell: HorizontalItemCell = tableView.dequeueReusableCell(withIdentifier: HorizontalItemCell.IDENTITY, for: indexPath) as! HorizontalItemCell
                
                let dogString: String = sitterDogs.map({ $0.name }).joined(separator: ",")
                cell.bind(data: HorizontalItemCell.DisplayData(
                    title: "\(sitter.overview.nickname)の愛犬",
                    value: !dogString.isEmpty ? dogString : "登録がありません"))
                cell.withMiddleWidthBottomBorder()
                return cell
            } else {
                return UITableViewCell()
            }
        case .Review:
            let cell: ReviewCell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.IDENTITY, for: indexPath) as! ReviewCell
            cell.bind(review: reviews[indexPath.row])
            return cell
        case .ReviewMore:
            let cell: UITableViewCell = tableDelegate.generateMoreReadCell()
            return cell
        case .Map:
            let cell: MapCell = tableView.dequeueReusableCell(withIdentifier: MapCell.IDENTITY, for: indexPath) as! MapCell
            cell.bind(address: sitter.address!)
            cell.hideAddress()
            return cell
        }
    }
    
    func bind() {
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
    
    func bind(sitter: Driver<Sitter?>) {
        sitter.filter({ $0 != nil })
            .drive(onNext: { sitter in
                self.sitter = sitter!
                self.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
    }
    
    func bind(dogs: Driver<[Dog]>) {
        dogs.drive(onNext: { dogs in
            self.sitterDogs = dogs
            self.tableView.reloadData()
        }).addDisposableTo(disposeBag)
    }
    
    func bind(reviewTotalCount: Driver<Int>) {
        reviewTotalCount.drive(onNext: { count in
            self.reviewTotalCount = count
            self.tableView.reloadData()
        }).addDisposableTo(disposeBag)
    }
}

extension SitterDetailDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch TableSection(rawValue: section)! {
        case .HouseThumbnail: fallthrough
        case .Tag: fallthrough
        case .Service: fallthrough
        case .Profile: fallthrough
        case .Review:
            return CGFloat(SearchTableDelegate.SECTION_HEIGHT)
        case .ReviewMore:
            return 0
        case .Map:
            if self.sitter.address != nil {
                return CGFloat(SearchTableDelegate.SECTION_HEIGHT)
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch TableSection(rawValue: indexPath.section)! {
        case .HouseThumbnail:
            break
        case .Tag:
            break
        case .Service:
            break
        case .Profile:
            break
        case .Review:
            break
        case .ReviewMore:
            self.action.value = .ReviewMore
        case .Map:
            self.action.value = .Map
        }
    }
}
