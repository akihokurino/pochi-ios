//
//  SignUpDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/22.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class SignUpDataSource: NSObject, UITableViewDataSource {
    
    private weak var delegate: UITextFieldDelegate? = nil
    fileprivate var formData: SignUpFormData = SignUpFormData()
    private let tableView: UITableView
    
    var observeInput: Observable<SignUpFormData.SendData> {
        return formData.observeInput()
    }
    
    init(tableView: UITableView, delegate: UITextFieldDelegate) {
        self.tableView = tableView
        self.delegate = delegate
        
        InputCellData.registerCell(tableView: self.tableView)
        
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formData.getProperties().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inputCellData: InputCellData = formData.getProperties()[indexPath.row]
        let cell: InputCell = inputCellData.getCell(tableView: tableView, indexPath: indexPath)
        
        (cell.getInput() as? UITextField)?.delegate = self.delegate
        
        return cell as! UITableViewCell
    }
    
    func bind() {
        self.tableView.reloadData()
    }
    
    func bind(auth: FbAuth) {
        formData.fireAuthType = .facebook
        formData.lastName.value.value = auth.lastName
        formData.firstName.value.value = auth.firstName
        formData.email.value.value = auth.email
        formData.password.value.value = "facebook"
        
        tableView.reloadData()
    }
}

extension SignUpDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return formData.getProperties()[indexPath.row].getCellHeight()
    }
}

