//
//  EditUserProfileDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/25.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class EditUserProfileDataSource: NSObject, UITableViewDataSource {
    
    private let tableView: UITableView
    private let tableDelegate: TableDelegate
    private weak var delegate: EditUserProfileViewController? = nil
    fileprivate var formData: EditProfileData = EditProfileData()
    
    var observeInput: Observable<EditProfileData.SendData> {
        return formData.observeInput()
    }
    
    init(tableView: UITableView, delegate: EditUserProfileViewController) {
        self.tableView = tableView
        self.tableDelegate = TableDelegate(tableView: tableView)
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
        
        switch cell.getInput() {
        case is UITextField:
            (cell.getInput() as! UITextField).delegate = self.delegate!
        case is UITextView:
            (cell.getInput() as! UITextView).delegate = self.delegate!
        default:
            break
        }
        
        cell.sync(data: inputCellData)
        return cell as! UITableViewCell
    }
    
    func bind(user: AppUser) {
        formData.nickName.value.value = user.overview.nickname
        formData.profile.value.value = user.introductionMessage
        
        self.tableView.reloadData()
    }
}

extension EditUserProfileDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return formData.getProperties()[indexPath.row].getCellHeight()
    }

}

