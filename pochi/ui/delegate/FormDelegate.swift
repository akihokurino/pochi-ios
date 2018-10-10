//
//  FormDelegate.swift
//  pochi
//
//  Created by akiho on 2017/01/22.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit

class FormDelegate {
    private static let INIT_TOP_INSETS: CGFloat = 0
    private var initBottomInsets: CGFloat = 0
    
    private var activeInput: UIView?
    private weak var scrollView: UIScrollView?
    
    init(scrollView: UIScrollView, initBottomInsets: CGFloat = 0) {
        self.scrollView = scrollView
        self.initBottomInsets = initBottomInsets
    }
    
    func setActiveTextInput(field: UIView?) {
        self.activeInput = field
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
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            guard let userInfo = notification.userInfo else {
                return
            }
            
            guard let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else {
                return
            }
            
            guard let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else {
                return
            }
            
            let convertedKeyboardFrame = self.scrollView?.superview?.convert(keyboardFrame, to: nil)
            
            let contentInsets = UIEdgeInsetsMake(FormDelegate.INIT_TOP_INSETS, 0, convertedKeyboardFrame!.size.height, 0)
            self.scrollView?.contentInset = contentInsets
            self.scrollView?.scrollIndicatorInsets = contentInsets
            
            if let activeInput = self.activeInput {
                let activeInputFrame = activeInput.superview?.convert(activeInput.frame, to: nil)
                let offsetY: CGFloat = activeInputFrame!.maxY - convertedKeyboardFrame!.minY
                
                if offsetY < 0 { return }
                
                UIView.beginAnimations("ResizeForKeyboard", context: nil)
                UIView.setAnimationDuration(animationDuration)
                
                self.scrollView?.contentOffset = CGPoint(x: 0, y: offsetY + FormDelegate.INIT_TOP_INSETS)
                
                UIView.commitAnimations()
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            self.scrollView?.contentInset = UIEdgeInsets.init(
                top: FormDelegate.INIT_TOP_INSETS,
                left: 0,
                bottom: self.initBottomInsets,
                right: 0)
            self.scrollView?.scrollIndicatorInsets = UIEdgeInsets.init(
                top: FormDelegate.INIT_TOP_INSETS,
                left: 0,
                bottom: self.initBottomInsets,
                right: 0)
        }
    }
}
