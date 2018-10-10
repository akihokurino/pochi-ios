//
//  UnderLineTextField.swift
//  pochi
//
//  Created by akiho on 2017/01/14.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class UnderLineTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addUnderline(height: 1.0, color: UIColor.inputBorderBottomColor())
    }
}
