//
//  SearchResultDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/21.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchResultDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType, SectionedViewDataSourceType {
    
    typealias Element = [Sitter]
    fileprivate var items: Element = []
    
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        
        self.tableView.register(SearchSitterCell.NIB, forCellReuseIdentifier: SearchSitterCell.IDENTITY)
        
        self.tableView.estimatedRowHeight = 48
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        super.init()
        
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, observedEvent: Event<[Sitter]>) {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchSitterCell = tableView.dequeueReusableCell(withIdentifier: SearchSitterCell.IDENTITY, for: indexPath) as! SearchSitterCell
        cell.bind(sitter: items[indexPath.row])
        return cell
    }
}

extension SearchResultDataSource: UITableViewDelegate {
    
}
