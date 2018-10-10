//
//  TextFieldExtension.swift
//  pochi
//
//  Created by Akiho on 2016/12/15.
//  Copyright © 2016年 akiho. All rights reserved.
//

import UIKit

extension UITextField {
    func addUnderline(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: UIScreen.main.bounds.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
    
    func removeUnderline() {
        self.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
    }
}
