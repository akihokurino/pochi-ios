//
//  SearchDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/20.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

// TODO: Historyはファーストリリースではださない
class SearchDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {

    fileprivate enum TableSection: Int, EnumEnumerable {
        case promotion
//        case history
        case title
        case host
    }
    
    enum Action {
        case none
        case showPromotion
        case reachedBottom
    }
    
    typealias Element = [Sitter]
    fileprivate var items: Element = []
    
    private let tableDelegate: SearchTableDelegate
    private var disposable: Disposable? = nil
    fileprivate let tableView: UITableView
    private var histories: [Sitter] = []
    private let disposeBag: DisposeBag = DisposeBag()
    fileprivate let selectItem: Variable<Sitter?> = Variable(nil)
    fileprivate let action: Variable<Action> = Variable(.none)
    
    var observeSelectItem: Driver<Sitter?> {
        return selectItem.asDriver()
    }
    
    var observeAction: Driver<Action> {
        return action.asDriver()
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableDelegate = SearchTableDelegate(tableView: tableView)
        
        self.tableView.register(SitterHistoriesCell.NIB, forCellReuseIdentifier: SitterHistoriesCell.IDENTITY)
        self.tableView.register(SearchSitterCell.NIB, forCellReuseIdentifier: SearchSitterCell.IDENTITY)
        self.tableView.register(SignUpPromotionCell.NIB, forCellReuseIdentifier: SignUpPromotionCell.IDENTITY)
        
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.cases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSection(rawValue: section)! {
        case .promotion:
            return AppUserStore.shared.restore() == nil ? 1 : 0
//        case .history:
//            return 1
        case .title:
            return 1
        case .host:
            return items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableSection(rawValue: indexPath.section)! {
        case .promotion:
            let cell: SignUpPromotionCell = tableView.dequeueReusableCell(withIdentifier: SignUpPromotionCell.IDENTITY, for: indexPath) as! SignUpPromotionCell
            return cell
//        case .history:
//            let cell: SitterHistoriesCell = tableView.dequeueReusableCell(withIdentifier: SitterHistoriesCell.IDENTITY, for: indexPath) as! SitterHistoriesCell
//            cell.bind(items: self.histories)
//            
//            self.disposable?.dispose()
//            self.disposable = cell.selectItem.asObservable().bindTo(selectItem)
//            
//            return cell
        case .title:
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            cell.textLabel?.text = "すべてのホスト"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
            cell.textLabel?.textColor = UIColor.sectionTitleColor()
            cell.backgroundColor = UIColor.backgroundColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        case .host:
            let cell: SearchSitterCell = tableView.dequeueReusableCell(withIdentifier: SearchSitterCell.IDENTITY, for: indexPath) as! SearchSitterCell
            cell.bind(sitter: items[indexPath.row])
            return cell
        }
    }
    
    func bind(histories: Driver<[Sitter]>) {
        histories
            .drive(onNext: { items in
                self.histories.append(contentsOf: items)
                self.tableView.reloadData()
            })
            .addDisposableTo(disposeBag)
    }
}

extension SearchDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch TableSection(rawValue: indexPath.section)! {
        case .promotion:
            self.action.value = .showPromotion
//        case .history:
//            break
        case .title:
            break
        case .host:
            self.selectItem.value = self.items[indexPath.row]
        }
    }
}
