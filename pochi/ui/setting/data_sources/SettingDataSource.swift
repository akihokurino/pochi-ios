//
//  SettingDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/22.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SettingDataSource: NSObject, UITableViewDataSource {
    
    fileprivate var items: [Section] {
        var sections = [
            Section(title: "その他", sectionHeight: 42, items: [
                Item(label: "利用規約", labelColor: UIColor.cellTitleColor(), hasArrow: false, isCenter: false, type: .ServiceTerms),
                Item(label: "プライバシーポリシー", labelColor: UIColor.cellTitleColor(), hasArrow: false, isCenter: false, type: .PrivacyPolicy),
                Item(label: "ソフトウェアライセンス", labelColor: UIColor.cellTitleColor(), hasArrow: true, isCenter: false, type: .License),
                Item(label: "アプリのバージョン", labelColor: UIColor.cellTitleColor(), hasArrow: false, isCenter: false, type: .Version)
            ])
        ]
        
        if AppUserStore.shared.restore() != nil {
            let items: [Item]
            if AppUserStore.shared.provider == .facebook {
                items = [
                    Item(label: "メールアドレスの変更", labelColor: UIColor.cellTitleColor(), hasArrow: true, isCenter: false, type: .ChangeEmail),
                    // Item(label: "支払い情報の登録・変更", labelColor: UIColor.cellTitleColor(), hasArrow: true, isCenter: false, type: .EditPaymentInfo),
                    // Item(label: "プッシュ通知設定", labelColor: UIColor.cellTitleColor(), hasArrow: true, isCenter: false, type: .PushNotification)
                ]
            } else {
                items = [
                    Item(label: "メールアドレスの変更", labelColor: UIColor.cellTitleColor(), hasArrow: true, isCenter: false, type: .ChangeEmail),
                    Item(label: "パスワードの変更", labelColor: UIColor.cellTitleColor(), hasArrow: true, isCenter: false, type: .ChangePassword)
                    // Item(label: "支払い情報の登録・変更", labelColor: UIColor.cellTitleColor(), hasArrow: true, isCenter: false, type: .EditPaymentInfo),
                    // Item(label: "プッシュ通知設定", labelColor: UIColor.cellTitleColor(), hasArrow: true, isCenter: false, type: .PushNotification)
                ]
            }
            sections.insert(Section(title: "アカウント情報", sectionHeight: 58, items: items), at: 0)
            
            sections.append(Section(title: "", sectionHeight: 20, items: [
                Item(label: "ログアウト", labelColor: UIColor.red, hasArrow: false, isCenter: true, type: .Logout)
            ]))
        }
        
        return sections
    }
    
    fileprivate var tableDelegate: SettingTableDelegate
    private let tableView: UITableView
    fileprivate let selectItem: Variable<Item.ItemType> = Variable(.None)
    
    var observeSelectItem: Driver<Item.ItemType> {
        return selectItem.asDriver()
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableDelegate = SettingTableDelegate(tableView: tableView)
        
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].getItems().count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableDelegate.generateSectionHeader(dataSource: items, section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableDelegate.generateCell(dataSource: items, indexPath: indexPath)
    }
    
    func bind() {
        self.tableView.reloadData()
    }
}

extension SettingDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(SettingTableDelegate.CELL_HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(items[section].getSectionHeight())
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectItem.value = items[indexPath.section].getItems()[indexPath.row].type
    }
}

