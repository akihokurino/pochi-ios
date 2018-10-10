//
//  InputCellData.swift
//  pochi
//
//  Created by akiho on 2017/02/05.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class InputCellData {
    enum InputType {
        case TextField
        case PickerTextField
        case DatePickerTextField
        case TextView
        case TextFieldWithSection
        case PickerTextFieldWithSection
        case CalendarTextField
    }

    let label: String
    let value: Variable<String> = Variable("")
    let type: InputType
    var selectItems: [String]?
    var isMask: Bool
    var isWriteOnce: Bool
    var calendarStartFrom: Date?
    var rightLabel: String
    var isNumberInput: Bool
    
    init(label: String,
         value: String,
         type: InputType,
         selectItems: [String]?,
         isMask: Bool = false,
         isWriteOnce: Bool = false,
         rightLabel: String = "",
         isNumberInput: Bool = false) {
        self.label = label
        self.value.value = value
        self.type = type
        self.selectItems = selectItems
        self.isMask = isMask
        self.isWriteOnce = isWriteOnce
        self.rightLabel = rightLabel
        self.isNumberInput = isNumberInput
    }
    
    func getCellHeight() -> CGFloat {
        switch type {
        case .TextField:
            return CGFloat(TextFieldCell.HEIGHT)
        case .PickerTextField:
            return CGFloat(PickerTextFieldCell.HEIGHT)
        case .DatePickerTextField:
            return CGFloat(DatePickerTextFieldCell.HEIGHT)
        case .TextView:
            return CGFloat(TextViewCell.HEIGHT)
        case .TextFieldWithSection:
            return CGFloat(TextFieldWithSectionCell.HEIGHT)
        case .PickerTextFieldWithSection:
            return CGFloat(PickerTextFieldWithSectionCell.HEIGHT)
        case .CalendarTextField:
            return CGFloat(CalendarTextFieldCell.HEIGHT)
        }
    }
    
    func getCell(tableView: UITableView, indexPath: IndexPath) -> InputCell {
        let cell: InputCell!
        switch type {
        case .TextField:
            cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.IDENTITY, for: indexPath) as! TextFieldCell
        case .PickerTextField:
            cell = tableView.dequeueReusableCell(withIdentifier: PickerTextFieldCell.IDENTITY, for: indexPath) as! PickerTextFieldCell
        case .DatePickerTextField:
            cell = tableView.dequeueReusableCell(withIdentifier: DatePickerTextFieldCell.IDENTITY, for: indexPath) as! DatePickerTextFieldCell
        case .TextView:
            cell = tableView.dequeueReusableCell(withIdentifier: TextViewCell.IDENTITY, for: indexPath) as! TextViewCell
        case .TextFieldWithSection:
            cell = tableView.dequeueReusableCell(withIdentifier: TextFieldWithSectionCell.IDENTITY, for: indexPath) as! TextFieldWithSectionCell
        case .PickerTextFieldWithSection:
            cell = tableView.dequeueReusableCell(withIdentifier: PickerTextFieldWithSectionCell.IDENTITY, for: indexPath) as! PickerTextFieldWithSectionCell
        case .CalendarTextField:
            cell = tableView.dequeueReusableCell(withIdentifier: CalendarTextFieldCell.IDENTITY, for: indexPath) as! CalendarTextFieldCell
        }
        
        cell.sync(data: self)
        
        if isMask && cell is TextFieldCell {
            (cell as? TextFieldCell)?.textField.isSecureTextEntry = true
        }
        
        return cell
    }
    
    static func registerCell(tableView: UITableView) {
        tableView.register(TextFieldCell.NIB, forCellReuseIdentifier: TextFieldCell.IDENTITY)
        tableView.register(PickerTextFieldCell.NIB, forCellReuseIdentifier: PickerTextFieldCell.IDENTITY)
        tableView.register(DatePickerTextFieldCell.NIB, forCellReuseIdentifier: DatePickerTextFieldCell.IDENTITY)
        tableView.register(TextViewCell.NIB, forCellReuseIdentifier: TextViewCell.IDENTITY)
        tableView.register(TextFieldWithSectionCell.NIB, forCellReuseIdentifier: TextFieldWithSectionCell.IDENTITY)
        tableView.register(PickerTextFieldWithSectionCell.NIB, forCellReuseIdentifier: PickerTextFieldWithSectionCell.IDENTITY)
        tableView.register(CalendarTextFieldCell.NIB, forCellReuseIdentifier: CalendarTextFieldCell.IDENTITY)
    }
}
