//
//  TaskListDataSource.swift
//  pochi
//
//  Created by akiho on 2017/05/27.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TaskListDataSource: RxTableViewSectionedReloadDataSource<UserTaskWithSection>, UITableViewDelegate {
    
    private let tableView: UITableView
    private let tableDelegate: TableDelegate
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableDelegate = TableDelegate(tableView: tableView)
        
        self.tableView.register(TaskCell.NIB, forCellReuseIdentifier: TaskCell.IDENTITY)
        
        super.init()
        
        self.configureCell = { (ds, tv, ip, item) -> TaskCell in
            let cell = tv.dequeueReusableCell(withIdentifier: TaskCell.IDENTITY, for: ip) as! TaskCell
            cell.bind(task: item)
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
        return CGFloat(TaskCell.HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(TableDelegate.SECTION_HEIGHT)
    }
}


