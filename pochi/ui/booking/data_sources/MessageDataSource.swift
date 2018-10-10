//
//  MessageDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MessageDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    
    typealias Element = [Message]
    fileprivate var items: Element = []

    private let disposeBag: DisposeBag = DisposeBag()
    private let tableView: UITableView
    
    init(tableView: UITableView) {
        self.tableView = tableView
        
        self.tableView.register(MyMessageCell.NIB, forCellReuseIdentifier: MyMessageCell.IDENTITY)
        self.tableView.register(YourMessageCell.NIB, forCellReuseIdentifier: YourMessageCell.IDENTITY)
        self.tableView.register(MyMessageImageCell.NIB, forCellReuseIdentifier: MyMessageImageCell.IDENTITY)
        self.tableView.register(YourMessageImageCell.NIB, forCellReuseIdentifier: YourMessageImageCell.IDENTITY)
        self.tableView.register(SystemMessageCell.NIB, forCellReuseIdentifier: SystemMessageCell.IDENTITY)
        
        self.tableView.estimatedRowHeight = 48
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        super.init()
        
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, observedEvent: Event<[Message]>) {
        if case .next(let items) = observedEvent {
            self.items = items
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message: Message = items[indexPath.row]
        switch message.type {
        case .user:
            if message.from.id == AppUserStore.shared.restore()!.overview.id {
                if message.imageUri != nil {
                    let cell: MyMessageImageCell = tableView.dequeueReusableCell(withIdentifier: MyMessageImageCell.IDENTITY, for: indexPath) as! MyMessageImageCell
                    cell.bind(message: message)
                    cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
                    return cell
                } else {
                    let cell: MyMessageCell = tableView.dequeueReusableCell(withIdentifier: MyMessageCell.IDENTITY, for: indexPath) as! MyMessageCell
                    cell.bind(message: message)
                    cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
                    return cell
                }
            } else {
                if message.imageUri != nil {
                    let cell: YourMessageImageCell = tableView.dequeueReusableCell(withIdentifier: YourMessageImageCell.IDENTITY, for: indexPath) as! YourMessageImageCell
                    cell.bind(message: message)
                    cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
                    return cell
                } else {
                    let cell: YourMessageCell = tableView.dequeueReusableCell(withIdentifier: YourMessageCell.IDENTITY, for: indexPath) as! YourMessageCell
                    cell.bind(message: message)
                    cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
                    return cell
                }
            }
        case .system:
            let cell: SystemMessageCell = tableView.dequeueReusableCell(withIdentifier: SystemMessageCell.IDENTITY, for: indexPath) as! SystemMessageCell
            cell.bind(message: message)
            cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
            return cell
        }
    }

}

extension MessageDataSource: UITableViewDelegate {
    
}

