//
//  CalendarView.swift
//  pochi
//
//  Created by akiho on 2017/03/07.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import FSCalendar
import RxSwift
import RxCocoa

class CalendarView: UIView {
    
    static let HEIGHT: CGFloat = 321
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    
    fileprivate var selectFrom: Date!
    fileprivate(set) var selectDate: Date?
    
    class func instance() -> CalendarView {
        let view = R.nib.calendarView.firstView(owner: nil, options: nil)!
        
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: CalendarView.HEIGHT)
        
        return view
    }
    
    func setup(selectFrom: Date?) {
        self.selectFrom = selectFrom ?? Date()
        self.calendar.locale = Locale(identifier: "ja_JP")
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
    }
    
    func show() {
        let targetY = UIScreen.main.bounds.height - containerView.frame.height
        containerView.translatesAutoresizingMaskIntoConstraints = true
        containerView.frame = CGRect(
            x: 0,
            y: UIScreen.main.bounds.height,
            width: UIScreen.main.bounds.width,
            height: self.containerView.frame.size.height)
        
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.containerView.frame = CGRect(
                    x: 0,
                    y: targetY,
                    width: UIScreen.main.bounds.width,
                    height: self.containerView.frame.size.height)
            },
            completion: { bool in
                self.containerView.translatesAutoresizingMaskIntoConstraints = false
            })
    }
    
    func hide(_ sender: UITapGestureRecognizer) {
        hide()
    }
    
    func hide() {
        self.containerView.translatesAutoresizingMaskIntoConstraints = true
        
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.containerView.frame = CGRect(
                    x: 0,
                    y: UIScreen.main.bounds.height,
                    width: UIScreen.main.bounds.width,
                    height: self.containerView.frame.size.height)
            },
            completion: { bool in
                self.containerView.translatesAutoresizingMaskIntoConstraints = false
                self.removeFromSuperview()
            })
    }
}

extension CalendarView: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectDate = Date(timeInterval: 60 * 60 * 9, since: date as Date)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return DateDelegate.dateToTimestamp(date: selectFrom) < DateDelegate.dateToTimestamp(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if DateDelegate.dateToTimestamp(date: selectFrom) >= DateDelegate.dateToTimestamp(date: date) {
            return UIColor.cancelGrayColor()
        } else {
            return UIColor.dateDefaultColor()
        }
    }
}
