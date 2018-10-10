//
//  MySitterProfileDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/25.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MySitterProfileDataSource: NSObject, UITableViewDataSource {
    
    fileprivate enum TableSection: Int, EnumEnumerable {
        case Profile
        case HouseData
//        case DogData
        case ServiceData
    }

    private let tableView: UITableView
    private let tableDelegate: TableDelegate
    private let disposeBag: DisposeBag = DisposeBag()
    private var sitter: Sitter? = nil
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableDelegate = TableDelegate(tableView: tableView)
        
        self.tableView.register(HorizontalItemCell.NIB, forCellReuseIdentifier: HorizontalItemCell.IDENTITY)
        self.tableView.register(VerticalItemCell.NIB, forCellReuseIdentifier: VerticalItemCell.IDENTITY)
        self.tableView.register(TextCell.NIB, forCellReuseIdentifier: TextCell.IDENTITY)
        
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
        if sitter == nil {
            return 0
        }
        
        switch TableSection(rawValue: section)! {
        case .Profile:
            return 1
        case .HouseData:
            return 6
//        case .DogData:
//            return 1
        case .ServiceData:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch TableSection(rawValue: section)! {
        case .Profile:
            return tableDelegate.generateSectionHeader(section: section, title: "プロフィール文章")
        case .HouseData:
            return tableDelegate.generateSectionHeader(section: section, title: "預かる家について")
//        case .DogData:
//            return tableDelegate.generateSectionHeader(section: section, title: "飼い犬についての詳細")
        case .ServiceData:
            return tableDelegate.generateSectionHeader(section: section, title: "世話や内容について")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableSection(rawValue: indexPath.section)! {
        case .Profile:
            let cell: TextCell = tableView.dequeueReusableCell(withIdentifier: TextCell.IDENTITY, for: indexPath) as! TextCell
            cell.bind(data: TextCell.DisplayData(text: sitter!.introductionMessage))
            return cell
        case .HouseData:
            let cell: HorizontalItemCell = tableView.dequeueReusableCell(withIdentifier: HorizontalItemCell.IDENTITY, for: indexPath) as! HorizontalItemCell
            
            if indexPath.row == 0 {
                let acceptableDogSizeLabel: String = sitter!.acceptableDogSizes.map({ type in
                    PublicAssetRepository.shared.dogSizeTypes.first(where: { $0.value == type.rawValue })?.label ?? ""
                }).joined(separator: "\n")
                cell.bind(data: HorizontalItemCell.DisplayData(
                    title: "世話が可能な犬のサイズ",
                    value: acceptableDogSizeLabel.isEmpty ? "未登録" : acceptableDogSizeLabel))
                cell.withMiddleWidthBottomBorder()
            } else if indexPath.row == 1 {
                let houseTypeLabel: String = PublicAssetRepository.shared.houseTypes.first(where: { $0.value == sitter?.houseType.rawValue })?.label ?? "未登録"
                cell.bind(data: HorizontalItemCell.DisplayData(
                    title: "家のタイプ",
                    value: houseTypeLabel))
                cell.withMiddleWidthBottomBorder()
            } else if indexPath.row == 2 {
                if let _sitter = self.sitter {
                    if _sitter.kidsTypes.isEmpty {
                        cell.bind(data: HorizontalItemCell.DisplayData(
                            title: "子供",
                            value: "未登録"))
                    } else {
                        let kidsTypeLabel: String = PublicAssetRepository.shared.kidsTypes.first(where: { $0.value == _sitter.kidsTypes[0].rawValue })?.label ?? "未登録"
                        cell.bind(data: HorizontalItemCell.DisplayData(
                            title: "子供",
                            value: kidsTypeLabel))
                    }
                } else {
                    cell.bind(data: HorizontalItemCell.DisplayData(
                        title: "子供",
                        value: "未登録"))
                }
                
                cell.withMiddleWidthBottomBorder()
            } else if indexPath.row == 3 {
                let isAvailable: Bool = sitter!.options.first(where: { option -> Bool in
                    return option == Sitter.Option.earlyMorning
                }) != nil
                cell.bind(data: HorizontalItemCell.DisplayData(
                    title: "朝早い時間の対応",
                    value: isAvailable ? "可能" : "不可能"))
                cell.withMiddleWidthBottomBorder()
            } else if indexPath.row == 4 {
                let isAvailable: Bool = sitter!.options.first(where: { option -> Bool in
                    return option == Sitter.Option.lateNight
                }) != nil
                cell.bind(data: HorizontalItemCell.DisplayData(
                    title: "夜遅い時間の対応",
                    value: isAvailable ? "可能" : "不可能"))
                cell.withMiddleWidthBottomBorder()
            } else if indexPath.row == 5 {
                let smokingTypeLabel: String = PublicAssetRepository.shared.smokingPolicies.first(where: { $0.value == sitter?.smokingPolicy.rawValue })?.label ?? "未登録"
                cell.bind(data: HorizontalItemCell.DisplayData(
                    title: "喫煙/禁煙の家",
                    value: smokingTypeLabel))
                cell.withFullWidthBottomBorder()
            }
            
            return cell
//        case .DogData:
//            let cell: VerticalItemCell = tableView.dequeueReusableCell(withIdentifier: VerticalItemCell.IDENTITY, for: indexPath) as! VerticalItemCell
//            return cell
        case .ServiceData:
            let cell: HorizontalItemCell = tableView.dequeueReusableCell(withIdentifier: HorizontalItemCell.IDENTITY, for: indexPath) as! HorizontalItemCell
            
            if indexPath.row == 0 {
                let dogKeepingTypeLabel: String = PublicAssetRepository.shared.dogKeepingStyles.first(where: { $0.value == sitter?.dogKeepingStyle.rawValue })?.label ?? "未登録"
                cell.bind(data: HorizontalItemCell.DisplayData(
                    title: "預かるスタイル",
                    value: dogKeepingTypeLabel))
                cell.withMiddleWidthBottomBorder()
            } else if indexPath.row == 1 {
                let walkingTypeLabel: String = PublicAssetRepository.shared.walkingPolicies.first(where: { $0.value == sitter?.walkingPolicy.rawValue })?.label ?? "未登録"
                cell.bind(data: HorizontalItemCell.DisplayData(
                    title: "預かるスタイル",
                    value: walkingTypeLabel))
                cell.withMiddleWidthBottomBorder()
            } else if indexPath.row == 2 {
                let acceptableDogTypeLabel: String = sitter!.acceptableDogTypes.map({ type in
                    PublicAssetRepository.shared.dogAttributes.first(where: { $0.value == type.rawValue })?.label ?? ""
                }).joined(separator: "\n")
                cell.bind(data: HorizontalItemCell.DisplayData(
                    title: "世話が可能な犬のタイプ",
                    value: acceptableDogTypeLabel.isEmpty ? "未登録" : acceptableDogTypeLabel))
                cell.withMiddleWidthBottomBorder()
            } else if indexPath.row == 3 {
                let unacceptableDogTypeLabel: String = sitter!.unacceptableDogTypes.map({ type in
                    PublicAssetRepository.shared.dogAttributes.first(where: { $0.value == type.rawValue })?.label ?? ""
                }).joined(separator: "\n")
                cell.bind(data: HorizontalItemCell.DisplayData(
                    title: "預かれない犬",
                    value: unacceptableDogTypeLabel.isEmpty ? "未登録" : unacceptableDogTypeLabel))
                cell.withFullWidthBottomBorder()
            }
            
            return cell
        }
    }
    
    func bind(sitter: Driver<Sitter?>) {
        sitter.drive(onNext: { sitter in
            self.sitter = sitter
            self.tableView.reloadData()
        })
        .addDisposableTo(disposeBag)
    }
}

extension MySitterProfileDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(TableDelegate.SECTION_HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
