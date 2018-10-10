//
//  InputPostalCodeDataSource.swift
//  pochi
//
//  Created by akiho on 2017/05/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class InputPostalCodeDataSource: NSObject, UITableViewDataSource {
    
    fileprivate var formData: InputPostalCodeData = InputPostalCodeData()
    private weak var delegate: UITextFieldDelegate? = nil
    private let tableView: UITableView
    private let keyboardDelegate: KeyboardDelegate
    
    init(tableView: UITableView, delegate: UITextFieldDelegate, container: UIViewController) {
        self.tableView = tableView
        self.delegate = delegate
        
        InputCellData.registerCell(tableView: self.tableView)
        keyboardDelegate = KeyboardDelegate(container: container)
        
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
        
        (cell.getInput() as! UITextField).delegate = self.delegate
        (cell.getInput() as! UITextField).keyboardType = .numberPad
        (cell.getInput() as! UITextField).placeholder = "郵便番号を入力（例：1510001）"
        
        keyboardDelegate.addCloseBtn(textField: cell.getInput() as! UITextField)
        
        return cell as! UITableViewCell
    }
    
    func observeInput() -> Observable<InputPostalCodeData.SendData> {
        return formData.observeInput()
    }
    
    func bind(zipCode: String) {
        self.formData.postalCode.value.value = zipCode
        self.tableView.reloadData()
    }
}

extension InputPostalCodeDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return formData.getProperties()[indexPath.row].getCellHeight()
    }
}


