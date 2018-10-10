//
//  RegisterBankAccountDataSource.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RegisterBankAccountDataSource: NSObject, UITableViewDataSource {
    
    enum Event {
        case none
        case closeKeyboard
    }
    
    fileprivate var formData: CreateBankAccountData = CreateBankAccountData()
    private let tableDelegate: SettingTableDelegate
    private let tableView: UITableView
    private weak var delegate: UITextFieldDelegate?
    private var event: Variable<Event> = Variable(.none)
    private var selectedBank: Bank? = nil
    
    var observeEvent: Driver<Event> {
        return event.asDriver()
    }
    
    var observeInput: Observable<CreateBankAccountData.SendData> {
        return formData.observeInput()
    }
    
    init(tableView: UITableView, delegate: UITextFieldDelegate) {
        self.tableView = tableView
        self.tableDelegate = SettingTableDelegate(tableView: tableView)
        self.delegate = delegate
        
        InputCellData.registerCell(tableView: tableView)
        
        super.init()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formData.getProperties().count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableDelegate.generateSectionHeader(section: section, title: selectedBank?.name ?? "")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inputCellData: InputCellData = formData.getProperties()[indexPath.row]
        let cell: InputCell = inputCellData.getCell(tableView: tableView, indexPath: indexPath)
        
        (cell.getInput() as! UITextField).delegate = self.delegate
        
        return cell as! UITableViewCell
    }
    
    func bind(bank: Bank) {
        self.selectedBank = bank
        self.tableView.reloadData()
    }
}

extension RegisterBankAccountDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(TableDelegate.SECTION_HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return formData.getProperties()[indexPath.row].getCellHeight()
    }
}

