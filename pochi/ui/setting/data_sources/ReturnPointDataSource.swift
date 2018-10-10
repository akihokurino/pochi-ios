//
//  ReturnPointDataSource.swift
//  pochi
//
//  Created by akiho on 2017/06/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ReturnPointDataSource: NSObject, UITableViewDataSource {
    fileprivate enum TableSection: Int, EnumEnumerable {
        case amount
        case bankAccount
    }
    
    enum Action {
        case none
        case selectBankAccount
    }
    
    private let tableDelegate: SettingTableDelegate
    private let tableView: UITableView
    fileprivate let action: Variable<Action> = Variable(.none)
    private weak var delegate: UITextFieldDelegate?
    private var selectedBankAccount: BankAccount?
    private let disposeBag: DisposeBag = DisposeBag()
    private var point: Variable<Int64> = Variable(0)
    private let keyboardDelegate: KeyboardDelegate
    
    var observePoint: Driver<Int64> {
        return point.asDriver()
    }
    
    var observeAction: Driver<Action> {
        return action.asDriver()
    }
    
    init(tableView: UITableView, delegate: UITextFieldDelegate, container: UIViewController) {
        self.tableView = tableView
        self.delegate = delegate
        self.tableDelegate = SettingTableDelegate(tableView: tableView)
        
        self.keyboardDelegate = KeyboardDelegate(container: container)
        
        self.tableView.register(TextFieldWithoutLabelCell.NIB, forCellReuseIdentifier: TextFieldWithoutLabelCell.IDENTITY)
        self.tableView.register(HorizontalItemInputCell.NIB, forCellReuseIdentifier: HorizontalItemInputCell.IDENTITY)
        
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.cases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSection(rawValue: section)! {
        case .amount:
            return 1
        case .bankAccount:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch TableSection(rawValue: section)! {
        case .amount:
            return tableDelegate.generateSectionHeader(section: section, title: "現金の振込申請をしたいポイント")
        case .bankAccount:
            return tableDelegate.generateSectionHeader(section: section, title: "銀行情報")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableSection(rawValue: indexPath.section)! {
        case .amount:
            let cell: TextFieldWithoutLabelCell = tableView.dequeueReusableCell(withIdentifier: TextFieldWithoutLabelCell.IDENTITY, for: indexPath) as! TextFieldWithoutLabelCell
            cell.bind(placeholder: "ポイント数を入力してください")
            cell.textField.delegate = delegate
            cell.textField.keyboardType = .numberPad
            cell.disposable?.dispose()
            cell.disposable = cell.textField.rx.text.asObservable()
                .filter({ $0 != nil })
                .map({ text -> Int64 in
                    Int64(text!) ?? 0
                })
                .bindTo(self.point)
            
            keyboardDelegate.addCloseBtn(textField: cell.textField)
            
            return cell
        case .bankAccount:
            switch indexPath.row {
            case 0:
                if let account = self.selectedBankAccount {
                    return tableDelegate.generateCell(title: account.name)
                } else {
                    return tableDelegate.generateCell(title: "選択してください")
                }
            default:
                let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
                return cell
            }
        }
    }
    
    func bind() {
        self.tableView.reloadData()
    }
    
    func bind(account: Driver<BankAccount?>) {
        account.drive(onNext: { account in
            self.selectedBankAccount = account
            self.tableView.reloadData()
        })
        .addDisposableTo(disposeBag)
    }
}

extension ReturnPointDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch TableSection(rawValue: section)! {
        case .amount: fallthrough
        case .bankAccount:
            return CGFloat(TableDelegate.SECTION_HEIGHT)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch TableSection(rawValue: indexPath.section)! {
        case .amount: fallthrough
        case .bankAccount:
            return CGFloat(TextFieldWithoutLabelCell.HEIGHT)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch TableSection(rawValue: indexPath.section)! {
        case .amount:
            break
        case .bankAccount:
            if indexPath.row == 0 {
                self.action.value = .selectBankAccount
            }
        }
    }
}

