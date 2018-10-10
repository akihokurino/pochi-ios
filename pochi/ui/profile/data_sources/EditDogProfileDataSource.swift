//
//  EditDogProfileDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/25.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class EditDogProfileDataSource: NSObject, UITableViewDataSource {
    
    private let tableView: UITableView
    private let tableDelegate: TableDelegate
    private weak var delegate: EditDogProfileViewController? = nil
    fileprivate var formData: EditDogData = EditDogData()
    
    var observeInput: Observable<EditDogData.SendData> {
        return formData.observeInput()
    }
    
    init(tableView: UITableView, delegate: EditDogProfileViewController) {
        self.tableView = tableView
        self.tableDelegate = TableDelegate(tableView: tableView)
        self.delegate = delegate
        
        formData.setupSelectItems()
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
    
    func bind(dog: Dog) {
        let breedLabel = PublicAssetRepository.shared.dogBreedTypes.filter({ $0.value == dog.breed }).first?.label ?? ""
        let genderLabel = PublicAssetRepository.shared.dogGenderTypes.filter({ $0.value == dog.gender }).first?.label ?? ""
        let sizeLabel = PublicAssetRepository.shared.dogSizeTypes.filter({ $0.value == dog.size }).first?.label ?? ""
        
        formData.name.value.value = dog.name
        formData.breed.value.value = breedLabel
        formData.gender.value.value = genderLabel
        formData.birthdate.value.value = dog.birthdate
        formData.size.value.value = sizeLabel
        self.tableView.reloadData()
    }
}

extension EditDogProfileDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return formData.getProperties()[indexPath.row].getCellHeight()
    }
}

