//
//  EditEmailDataSource.swift
//  pochi
//
//  Created by akiho on 2017/06/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class EditEmailDataSource: NSObject, UITableViewDataSource {
    
    fileprivate var formData: EditEmailData = EditEmailData()
    private weak var delegate: UITextFieldDelegate? = nil
    private let tableView: UITableView
    
    var observeInput: Observable<EditEmailData.SendData> {
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
        
        (cell.getInput() as! UITextField).delegate = self.delegate
        
        return cell as! UITableViewCell
    }
    
    func bind(user: AppUser) {
        formData.email.value.value = user.email
        self.tableView.reloadData()
    }
}

extension EditEmailDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return formData.getProperties()[indexPath.row].getCellHeight()
    }
}


