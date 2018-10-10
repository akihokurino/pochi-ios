//
//  SettingPushNotificationDataSource.swift
//  pochi
//
//  Created by akiho on 2017/06/05.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SettingPushNotificationDataSource: NSObject, UITableViewDataSource {
    
    private let tableDelegate: SettingTableDelegate
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableDelegate = SettingTableDelegate(tableView: tableView)
        
        self.tableView.register(HorizontalItemSwitchCell.NIB, forCellReuseIdentifier: HorizontalItemSwitchCell.IDENTITY)
        
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableDelegate.generateSectionHeader(section: section, title: "プッシュ通知")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HorizontalItemSwitchCell = tableView.dequeueReusableCell(withIdentifier: HorizontalItemSwitchCell.IDENTITY, for: indexPath) as! HorizontalItemSwitchCell
        return cell
    }
    
    func bind() {
        self.tableView.reloadData()
    }
}

extension SettingPushNotificationDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(TableDelegate.SECTION_HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(HorizontalItemSwitchCell.HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

