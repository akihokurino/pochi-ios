//
//  EditSitterProfileDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/25.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class EditSitterProfileDataSource: NSObject, UITableViewDataSource {
    
    private let tableView: UITableView
    private let tableDelegate: TableDelegate
    private weak var delegate: EditSitterProfileViewController? = nil
    fileprivate var formData: EditSitterProfileData = EditSitterProfileData()
    
    init(tableView: UITableView, delegate: EditSitterProfileViewController) {
        self.tableView = tableView
        self.tableDelegate = TableDelegate(tableView: tableView)
        self.delegate = delegate
        
        InputCellData.registerCell(tableView: self.tableView)
        
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EditSitterProfileData.getSectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formData.getPropertiesForSection(section: EditSitterProfileData.TableSection(rawValue: section)!).count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            cell.textLabel?.text = formData.getSectionTitle(
                section: EditSitterProfileData.TableSection(rawValue: indexPath.section)!)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.textLabel?.textColor = UIColor.sectionTitleColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.backgroundColor = UIColor.backgroundColor()
            return cell
        } else {
            let index = self.realIndex(indexPath: indexPath)
            let inputCellData: InputCellData = formData.getPropertiesForSection(
                section: EditSitterProfileData.TableSection(rawValue: indexPath.section)!)[index]
            let cell = formData.getPropertiesForSection(
                section: EditSitterProfileData.TableSection(rawValue: indexPath.section)!)[index]
                .getCell(tableView: tableView, indexPath: indexPath)
            
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
    }
    
    fileprivate func realIndex(indexPath: IndexPath) -> Int {
        return indexPath.row - 1
    }

    func bind() {
        self.tableView.reloadData()
    }
}

extension EditSitterProfileDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        } else {
            let index = self.realIndex(indexPath: indexPath)
            return formData.getPropertiesForSection(
                section: EditSitterProfileData.TableSection(rawValue: indexPath.section)!)[index]
                .getCellHeight()
        }
    }
}

