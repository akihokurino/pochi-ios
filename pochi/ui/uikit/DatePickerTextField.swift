//
//  DatePickerTextField.swift
//  pochi
//
//  Created by akiho on 2017/01/21.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class DatePickerTextField: UITextField {
    
    private let picker: UIDatePicker = UIDatePicker()
    init() {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addUnderline(height: 1.0, color: UIColor.inputBorderBottomColor())
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addUnderline(height: 1.0, color: UIColor.inputBorderBottomColor())
        
        setup()
    }
    
    func setup() {
        picker.datePickerMode = UIDatePickerMode.date
        // 一旦現状の仕様に合わせて過去の日付だけ指定できるようにする
        picker.maximumDate = Date()
        picker.addTarget(self,
                         action: #selector(DatePickerTextField.changedDateEvent(sender:)),
                         for: UIControlEvents.valueChanged)
        picker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(
            title: "完了",
            style: .plain,
            target: self,
            action: #selector(DatePickerTextField.done))
        doneItem.tintColor = UIColor.activeColor()
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
        toolbar.setItems([flexibleItem, doneItem], animated: true)
        
        self.inputView = picker
        self.inputAccessoryView = toolbar
    }
    
    func changedDateEvent(sender: AnyObject?) {
        let dateSelecter: UIDatePicker = sender as! UIDatePicker
        self.changeLabelDate(date: dateSelecter.date as NSDate)
    }
    
    func changeLabelDate(date: NSDate) {
        self.text = self.dateToString(date: date)
    }
    
    func dateToString(date: NSDate) -> String {
        let date_formatter: DateFormatter = DateFormatter()
        date_formatter.locale = NSLocale(localeIdentifier: "ja") as Locale!
        date_formatter.dateFormat = "yyyy-MM-dd"
        return date_formatter.string(from: date as Date)
    }
    
    func done() {
        
        self.endEditing(true)
    }
}
