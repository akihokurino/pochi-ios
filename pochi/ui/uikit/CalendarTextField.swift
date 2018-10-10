//
//  CalendarTextField.swift
//  pochi
//
//  Created by akiho on 2017/10/23.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation

protocol CalendarTextFieldDelegate: class {
    func select(value: Date)
}

class CalendarTextField: UITextField {
    
    private var calendarView: CalendarView?
    
    weak var customDelegate: CalendarTextFieldDelegate?
    
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
    
    func setup(selectFrom: Date?) {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(
            title: "完了",
            style: .plain,
            target: self,
            action: #selector(CalendarTextField.done))
        doneItem.tintColor = UIColor.activeColor()
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleItem, doneItem], animated: true)
        
        calendarView = CalendarView.instance()
        calendarView?.setup(selectFrom: selectFrom)
        self.inputView = calendarView
        self.inputAccessoryView = toolbar
    }
    
    func done() {
        if let date = calendarView?.selectDate {
            self.text = DateDelegate.dateToDateString(date: date)
            self.endEditing(true)
            
            customDelegate?.select(value: date)
        }
    }
}
