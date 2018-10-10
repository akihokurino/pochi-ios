//
//  NoticeListDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/23.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class NoticeListDataSource: RxTableViewSectionedReloadDataSource<NoticeWithSection>, UITableViewDelegate {

    private let tableView: UITableView
    private let tableDelegate: TableDelegate
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableDelegate = TableDelegate(tableView: tableView)
        
        self.tableView.register(NoticeCell.NIB, forCellReuseIdentifier: NoticeCell.IDENTITY)
        
        super.init()
        
        self.configureCell = { (ds, tv, ip, item) -> NoticeCell in
            let cell = tv.dequeueReusableCell(withIdentifier: NoticeCell.IDENTITY, for: ip) as! NoticeCell
            return cell
        }
        
        self.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].header
        }
        
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableDelegate.generateSectionHeader(section: section, title: "2017年11月10日")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(NoticeCell.HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(TableDelegate.SECTION_HEIGHT)
    }
}

