//
//  LicenseListDataSource.swift
//  pochi
//
//  Created by akiho on 2017/09/03.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class LicenseListDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    
    typealias Element = [String]
    fileprivate var items: Element = []
    
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        super.init()
        
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, observedEvent: Event<[String]>) {
        if case .next(let items) = observedEvent {
            self.items = items
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = UIColor.cellTitleColor()
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        return cell
    }
}

extension LicenseListDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40)
    }
}
