//
//  CreateDogDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/22.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class CreateDogDataSource: NSObject, UITableViewDataSource {
    
    private weak var delegate: UITextFieldDelegate? = nil
    fileprivate var formSections: [CreateDogData] = []
    private let tableView: UITableView
    private let tableDelegate: TableDelegate
    private var deleteActionDisposable: Disposable? = nil
    private var insertActionDisposable: Disposable? = nil
    
    var observeInput: Observable<CreateDogData.SendData> {
        return formSections[0].observeInput()
    }
    
    init(tableView: UITableView, delegate: UITextFieldDelegate) {
        self.tableView = tableView
        self.delegate = delegate
        self.tableDelegate = TableDelegate(tableView: tableView)
        
        let formData1 = CreateDogData()
        formData1.setupSelectItems()
        formSections.append(formData1)
        
        InputCellData.registerCell(tableView: self.tableView)
        
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return formSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formSections[section].getProperties().count + 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
            cell.textLabel?.text = "新しい愛犬の登録"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13.0)
            cell.textLabel?.textColor = UIColor.sectionTitleColor()
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.backgroundColor = UIColor.backgroundColor()
            
            if indexPath.section > 0 {
                let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 100, y: 0, width: 100, height: 40))
                btn.setTitleColor(UIColor.activeColor(), for: .normal)
                btn.setTitle("削除する", for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
                cell.addSubview(btn)
                deleteActionDisposable?.dispose()
                deleteActionDisposable = btn.rx.tap
                    .asDriver()
                    .map({ indexPath.section })
                    .drive(onNext: { sectionIndex in
                        self.formSections.remove(at: sectionIndex)
                        self.tableView.reloadData()
                    })
            }
            
            return cell
        } else if indexPath.row == formSections[indexPath.section].getProperties().count + 1 {
            if indexPath.section == formSections.count - 1 {
                let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.backgroundColor = UIColor.backgroundColor()
                
                let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 200, y: 0, width: 200, height: 40))
                btn.setTitleColor(UIColor.activeColor(), for: .normal)
                btn.setTitle("愛犬を追加する", for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
                cell.addSubview(btn)
                insertActionDisposable?.dispose()
                insertActionDisposable = btn.rx.tap
                    .asDriver()
                    .drive(onNext: {
                        let newForm = CreateDogData()
                        newForm.setupSelectItems()
                        self.formSections.append(newForm)
                        self.tableView.reloadData()
                    })
                
                return cell
            } else {
                let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.backgroundColor = UIColor.backgroundColor()
                return cell
            }
        } else {
            let inputCellData: InputCellData = formSections[indexPath.section].getProperties()[indexPath.row - 1]
            let cell: InputCell = inputCellData.getCell(tableView: tableView, indexPath: indexPath)
            
            (cell.getInput() as! UITextField).delegate = self.delegate
            
            return cell as! UITableViewCell
        }
    }
    
    func bind() {
        self.tableView.reloadData()
    }
    
    func getMoreDogData() -> [CreateDogData.SendData] {
        if formSections.count > 1 {
            let more = formSections[1..<formSections.count]
            return more.map({ $0.getSendData() }).filter({ $0.isAllInputFilled() })
        } else {
            return []
        }
    }
}

extension CreateDogDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 40
        } else if indexPath.row == formSections[indexPath.section].getProperties().count + 1 {
            return indexPath.section == formSections.count - 1 ? 40 : 0
        } else {
            return formSections[indexPath.section].getProperties()[indexPath.row - 1].getCellHeight()
        }
    }
}


