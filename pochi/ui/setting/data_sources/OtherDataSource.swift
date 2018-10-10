//
//  OtherDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/22.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class OtherDataSource: NSObject, UITableViewDataSource {
    
    fileprivate var items: [Section] {
        var sections = [
            // TODO: お知らせはファーストリリースでは出さない
//            Section(title: "お知らせ", sectionHeight: 42, items: [
//                Item(label: "運営からのお知らせ", labelColor: UIColor.cellTitleColor(), hasArrow: true, isCenter: false, type: .Notice)
//                ]),
            Section(title: "設定・ヘルプ", sectionHeight: 42, items: [
                Item(label: "設定", labelColor: UIColor.cellTitleColor(), hasArrow: true, isCenter: false, type: .Setting),
                Item(label: "ヘルプ", labelColor: UIColor.cellTitleColor(), hasArrow: false, isCenter: false, type: .Help),
                Item(label: "安心サポート", labelColor: UIColor.cellTitleColor(), hasArrow: false, isCenter: false, type: .Support),
                Item(label: "不具合報告はこちら", labelColor: UIColor.cellTitleColor(), hasArrow: false, isCenter: false, type: .ReportBug)
                ])
        ]
        
        if let _ = AppUserStore.shared.restore() {
            sections.insert(Section(title: "アカウント情報", sectionHeight: 42, items: [
                Item(label: "プロフィール", labelColor: UIColor.cellTitleColor(), hasArrow: false, isCenter: false, type: .Profile),
                Item(label: "愛犬プロフィール", labelColor: UIColor.cellTitleColor(), hasArrow: false, isCenter: false, type: .DogProfile),
                Item(label: "ホストプロフィール", labelColor: UIColor.cellTitleColor(), hasArrow: false, isCenter: false, type: .HostProfile),
                Item(label: "振込先銀行口座", labelColor: UIColor.cellTitleColor(), hasArrow: true, isCenter: false, type: .SettingBank),
                Item(label: "現金振込申請", labelColor: UIColor.cellTitleColor(), hasArrow: true, isCenter: false, type: .ReturnPoint)
                ]), at: 1)
            
            sections.insert(Section(title: "終了した予約", sectionHeight: 42, items: [
                Item(label: "お泊りが終了した予約", labelColor: UIColor.cellTitleColor(), hasArrow: true, isCenter: false, type: .FinishedLeave),
                Item(label: "受け入れが終了した予約", labelColor: UIColor.cellTitleColor(), hasArrow: true, isCenter: false, type: .FinishedKeep)
                ]), at: 2)
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

extension OtherDataSource: UITableViewDelegate {
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
