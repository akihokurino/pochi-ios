//
//  UIViewExtension.swift
//  pochi
//
//  Created by akiho on 2017/03/10.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addBottomBorder() {
        let borderView = UIView(frame: CGRect(
            x: 0,
            y: Int(self.bounds.size.height - 1),
            width: Int(self.bounds.size.width),
            height: 1
        ))
        borderView.backgroundColor = UIColor.inActiveColor()
        
        self.addSubview(borderView)
    }
    
    func addBottomBorder(width: Int) {
        let borderView = UIView(frame: CGRect(
            x: 0,
            y: Int(self.bounds.size.height - 1),
            width: width,
            height: 1
        ))
        borderView.backgroundColor = UIColor.inActiveColor()
        
        self.addSubview(borderView)
    }
    
    func addBottomBorder(width: Int, y: Int) {
        let borderView = UIView(frame: CGRect(
            x: 0,
            y: y,
            width: width,
            height: 1
        ))
        borderView.backgroundColor = UIColor.inActiveColor()
        
        self.addSubview(borderView)
    }
}
