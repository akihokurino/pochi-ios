//
//  UnderLineTextView.swift
//  pochi
//
//  Created by akiho on 2017/02/06.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class UnderLineTextView: UITextView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addUnderline(height: 1.0, color: UIColor.inputBorderBottomColor())
    }
}
