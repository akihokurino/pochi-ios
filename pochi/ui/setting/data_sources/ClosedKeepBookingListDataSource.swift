//
//  ClosedKeepBookingListDataSource.swift
//  pochi
//
//  Created by akiho on 2017/06/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ClosedKeepBookingListDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    
    typealias Element = [Booking]
    fileprivate var items: Element = []
    
    private let tableDelegate: SettingTableDelegate
    private var disposable: Disposable? = nil
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableDelegate = SettingTableDelegate(tableView: tableView)
        
        self.tableView.register(ClosedKeepBookingCell.NIB, forCellReuseIdentifier: ClosedKeepBookingCell.IDENTITY)
        
        super.init()
        
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, observedEvent: Event<[Booking]>) {
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
        let cell: ClosedKeepBookingCell = tableView.dequeueReusableCell(withIdentifier: ClosedKeepBookingCell.IDENTITY, for: indexPath) as! ClosedKeepBookingCell
        cell.bind(booking: items[indexPath.row])
        return cell
    }
}

extension ClosedKeepBookingListDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(ClosedKeepBookingCell.HEIGHT)
    }
}
