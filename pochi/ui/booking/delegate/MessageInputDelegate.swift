//
//  MessageInputDelegate.swift
//  pochi
//
//  Created by Akiho on 2017/02/15.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit

class MessageInputDelegate {
    private let inputView: MessageInputView
    private var lockAnimation: Bool = false
    
    init(inputView: MessageInputView) {
        self.inputView = inputView
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
            if let keyboard = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue{
                let keyBoardRect = keyboard.cgRectValue
                
                self.inputView.frame = CGRect(
                    x: 0,
                    y: UIScreen.main.bounds.size.height - keyBoardRect.size.height - self.inputView.frame.size.height,
                    width: self.inputView.frame.size.width,
                    height: self.inputView.frame.size.height)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        guard !lockAnimation else {
            return
        }

        inputView.reset()
    }
    
    func hideKeyboard() {
        let _ = inputView.textView.resignFirstResponder()
    }
    
    func lock() {
        lockAnimation = true
    }
    
    func unLock() {
        lockAnimation = false
    }
}

