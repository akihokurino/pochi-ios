//
//  DogProfileDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/25.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DogProfileDataSource: RxTableViewSectionedReloadDataSource<DogWithSection>, UITableViewDelegate {
    
    private let tableView: UITableView
    private let tableDelegate: TableDelegate
    private let disposeBag: DisposeBag = DisposeBag()
    private let selectDog: Variable<Dog?> = Variable(nil)
    
    var observeSelectDog: Driver<Dog?> {
        return selectDog.asDriver()
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
        self.tableDelegate = TableDelegate(tableView: tableView)
        
        self.tableView.register(DogProfileCell.NIB, forCellReuseIdentifier: DogProfileCell.IDENTITY)
        
        super.init()
        
        self.configureCell = { (ds, tv, ip, item) -> DogProfileCell in
            let cell = tv.dequeueReusableCell(withIdentifier: DogProfileCell.IDENTITY, for: ip) as! DogProfileCell
            cell.bind(dog: item)
            cell.disposable?.dispose()
            cell.disposable = cell.observeEditBtn
                .drive(onNext: {
                    self.selectDog.value = item
                })
            return cell
        }
        
        self.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].header
        }
        
        self.tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableDelegate.generateSectionHeader(section: section, title: "\(section + 1)匹目のプロフィール")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(TableDelegate.SECTION_HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(DogProfileCell.HEIGHT)
    }
    
    func bind() {
        tableView.reloadData()
    }
}
