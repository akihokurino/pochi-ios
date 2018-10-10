//
//  ReviewTaskDataSource.swift
//  pochi
//
//  Created by akiho on 2017/05/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ReviewTaskDataSource: NSObject, UITableViewDataSource {
    fileprivate enum TableSection: Int, EnumEnumerable {
        case review
        case comment
    }
    
    enum Action {
        case none
        case review
    }
    
    private let tableDelegate: TableDelegate
    private let tableView: UITableView
    fileprivate let action: Variable<Action> = Variable(.none)
    private weak var delegate: UITextViewDelegate? = nil
    private var currentReviewScore: Int = 0
    
    var observeAction: Driver<Action> {
        return action.asDriver()
    }
    
    init(tableView: UITableView, delegate: UITextViewDelegate) {
        self.tableView = tableView
        self.delegate = delegate
        self.tableDelegate = TableDelegate(tableView: tableView)
        
        self.tableView.register(InputReviewCell.NIB, forCellReuseIdentifier: InputReviewCell.IDENTITY)
        self.tableView.register(TextViewWithoutLabelCell.NIB, forCellReuseIdentifier: TextViewWithoutLabelCell.IDENTITY)
        
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.cases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSection(rawValue: section)! {
        case .review:
            return 1
        case .comment:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch TableSection(rawValue: section)! {
        case .review:
            return tableDelegate.generateSectionHeader(section: section, title: "星で評価")
        case .comment:
            return tableDelegate.generateSectionHeader(section: section, title: "コメント")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableSection(rawValue: indexPath.section)! {
        case .review:
            let cell: InputReviewCell = tableView.dequeueReusableCell(withIdentifier: InputReviewCell.IDENTITY, for: indexPath) as! InputReviewCell
            cell.bind(score: Double(currentReviewScore))
            return cell
        case .comment:
            let cell: TextViewWithoutLabelCell = tableView.dequeueReusableCell(withIdentifier: TextViewWithoutLabelCell.IDENTITY, for: indexPath) as! TextViewWithoutLabelCell
            cell.textView.delegate = delegate
            return cell
        }
    }
    
    func bind() {
        self.tableView.reloadData()
    }
    
    func bind(score: Int) {
        self.currentReviewScore = score
        self.tableView.reloadData()
    }
}

extension ReviewTaskDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch TableSection(rawValue: section)! {
        case .review: fallthrough
        case .comment:
            return CGFloat(TableDelegate.SECTION_HEIGHT)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch TableSection(rawValue: indexPath.section)! {
        case .review:
            return CGFloat(InputReviewCell.HEIGHT)
        case .comment:
            return CGFloat(TextViewWithoutLabelCell.HEIGHT)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch TableSection(rawValue: indexPath.section)! {
        case .review:
            self.action.value = .review
        case .comment:
            break
        }
    }
}

