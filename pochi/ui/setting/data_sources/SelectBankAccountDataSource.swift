//
//  SelectBankAccountDataSource.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SelectBankAccountDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType, SectionedViewDataSourceType {
    
    typealias Element = [BankAccount]
    fileprivate var items: Element = []
    
    private let tableDelegate: SettingTableDelegate
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableDelegate = SettingTableDelegate(tableView: tableView)
        
        self.tableView.register(BankAccountCell.NIB, forCellReuseIdentifier: BankAccountCell.IDENTITY)
        
        super.init()
        
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, observedEvent: Event<[BankAccount]>) {
        if case .next(let items) = observedEvent {
            self.items = items
            tableView.reloadData()
        }
    }
    
    func model(at indexPath: IndexPath) throws -> Any {
        return items[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableDelegate.generateSectionHeader(section: section, title: "")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BankAccountCell = tableView.dequeueReusableCell(withIdentifier: BankAccountCell.IDENTITY, for: indexPath) as! BankAccountCell
        cell.bind(account: items[indexPath.row])
        return cell
    }
}

extension SelectBankAccountDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(TableDelegate.SECTION_HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(BankAccountCell.HEIGHT)
    }
}
