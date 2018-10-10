//
//  MessageTableDelegate.swift
//  pochi
//
//  Created by akiho on 2017/02/08.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit

class MessageTableDelegate: TableDelegate {
    
    private var lockAnimation: Bool = false
    
    override init(tableView: UITableView) {
        super.init(tableView: tableView)
    }
    
    func setup() {
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(keyboardWillBeShown(notification:)),
                         name: NSNotification.Name.UIKeyboardWillShow,
                         object: nil)
        NotificationCenter
            .default
            .addObserver(self,
                         selector: #selector(keyboardWillBeHidden(notification:)),
                         name: NSNotification.Name.UIKeyboardWillHide,
                         object: nil)
    }
    
    func reset() {
        NotificationCenter
            .default
            .removeObserver(self,
                            name: NSNotification.Name.UIKeyboardWillShow,
                            object: nil)
        NotificationCenter
            .default
            .removeObserver(self,
                            name: NSNotification.Name.UIKeyboardWillHide,
                            object: nil)
    }
    
    @objc func keyboardWillBeShown(notification: NSNotification) {
        guard !lockAnimation else {
            return
        }
        
        if let userInfo = notification.userInfo{
            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue,
                let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
                self.restoreScrollViewSize()
                
                let convertedKeyboardFrame = tableView?.superview?.convert(keyboardFrame, to: nil)
    
                self.updateScrollViewSize(moveSize: convertedKeyboardFrame!.size.height, duration: animationDuration)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        guard !lockAnimation else {
            return
        }
        
        restoreScrollViewSize()
    }
    
    private func updateScrollViewSize(moveSize: CGFloat, duration: TimeInterval) {
        let contentInsets = UIEdgeInsetsMake(moveSize, 0, 48, 0)
        
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(duration)
        
        tableView?.contentInset = contentInsets
        tableView?.scrollIndicatorInsets = contentInsets
        
        let top = tableView?.contentInset.top ?? 0
        tableView?.contentOffset = CGPoint(x: 0, y: -top)
        
        UIView.commitAnimations()
    }
    
    private func restoreScrollViewSize() {
        tableView?.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 48, right: 0)
        tableView?.scrollIndicatorInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 48, right: 0)
    }
    
    func lock() {
        lockAnimation = true
    }
    
    func unLock() {
        lockAnimation = false
    }
}
