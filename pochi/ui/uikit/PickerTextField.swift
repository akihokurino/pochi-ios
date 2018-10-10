//
//  PickerTextField.swift
//  pochi
//
//  Created by akiho on 2016/12/18.
//  Copyright © 2016年 akiho. All rights reserved.
//

import UIKit

protocol PickerTextFieldDelegate: class {
    func select(value: String)
}

class PickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var dataList = [String]()
    private var isWriteOnce: Bool = false
    private var selectedIndex: Int = 0
    
    weak var customDelegate: PickerTextFieldDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addUnderline(height: 1.0, color: UIColor.inputBorderBottomColor())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addUnderline(height: 1.0, color: UIColor.inputBorderBottomColor())
    }
    
    func setup(dataList: [String], isWriteOnce: Bool = false) {
        self.dataList = dataList
        self.isWriteOnce = isWriteOnce
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(
            title: "完了",
            style: .plain,
            target: self,
            action: #selector(PickerTextField.done))
        doneItem.tintColor = UIColor.activeColor()
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleItem, doneItem], animated: true)
        
        self.inputView = picker
        self.inputAccessoryView = toolbar
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
    
    func done() {
        guard let text = self.text else {
            return
        }
        
        if isWriteOnce {
            if text.isEmpty {
                self.text = dataList[selectedIndex]
            } else {
                let current = text.components(separatedBy: ",")
                let next = dataList[selectedIndex]
                if !current.contains(next) {
                    self.text = "\(text),\(next)"
                }
            }
        } else {
            self.text = dataList[selectedIndex]
        }
        
        customDelegate?.select(value: text)
        self.endEditing(true)
    }
}
