//
//  KeyboardDelegate.swift
//  pochi
//
//  Created by akiho on 2017/09/09.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit

class KeyboardDelegate {
    
    private weak var container: UIViewController?
    
    init(container: UIViewController) {
        self.container = container
    }
    
    func addCloseBtn(textField: UITextField) {
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: UIScreen.main.bounds.width,
                                              height: 40))
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let closeBtn = UIBarButtonItem(title: "閉じる", style: .done, target: self, action: #selector(self.close))
        
        toolBar.items = [spacer, closeBtn]
        textField.inputAccessoryView = toolBar
    }
    
    @objc func close() {
        self.container?.view.endEditing(true)
    }
}
