//
//  NoticeDetailDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/23.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class NoticeDetailDataSource: NSObject, UITableViewDataSource {
    
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        
        self.tableView.estimatedRowHeight = 48
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.register(NoticeDetailCell.NIB, forCellReuseIdentifier: NoticeDetailCell.IDENTITY)
        
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NoticeDetailCell = tableView.dequeueReusableCell(withIdentifier: NoticeDetailCell.IDENTITY, for: indexPath) as! NoticeDetailCell
        return cell
    }
    
    func bind() {
        self.tableView.reloadData()
    }
}

extension NoticeDetailDataSource: UITableViewDelegate {
    
}
