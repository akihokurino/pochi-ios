//
//  UITextViewExtension.swift
//  pochi
//
//  Created by akiho on 2017/02/06.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

extension UITextView {
    func addUnderline(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: UIScreen.main.bounds.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
