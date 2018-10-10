//
//  BookingListDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class BookingListDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType, SectionedViewDataSourceType {
    
    typealias Element = [Booking]
    fileprivate var items: Element = []

    private let disposeBag: DisposeBag = DisposeBag()
    private let tableDelegate: MessageTableDelegate
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableDelegate = MessageTableDelegate(tableView: tableView)
        
        self.tableView.register(BookingCell.NIB, forCellReuseIdentifier: BookingCell.IDENTITY)
        
        super.init()
        
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, observedEvent: Event<[Booking]>) {
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
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookingCell = tableView.dequeueReusableCell(withIdentifier: BookingCell.IDENTITY, for: indexPath) as! BookingCell
        cell.bind(booking: items[indexPath.row])
        return cell
    }
}

extension BookingListDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(BookingCell.HEIGHT)
    }
}
