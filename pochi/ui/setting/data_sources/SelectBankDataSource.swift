//
//  SelectBankDataSource.swift
//  pochi
//
//  Created by akiho on 2017/06/06.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SelectBankDataSource: RxTableViewSectionedReloadDataSource<BankWithSection>, UITableViewDelegate {
    
    private let tableView: UITableView
    private let tableDelegate: SettingTableDelegate
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableDelegate = SettingTableDelegate(tableView: tableView)
        
        super.init()
        
        self.configureCell = { (ds, tv, ip, item) -> UITableViewCell in
            let cell = self.tableDelegate.generateCell(title: item.name)
            return cell
        }
        
        self.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].header
        }
        
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableDelegate.generateSectionHeader(section: section, title: self.sectionModels[section].header)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(SettingTableDelegate.CELL_HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(TableDelegate.SECTION_HEIGHT)
    }
}

