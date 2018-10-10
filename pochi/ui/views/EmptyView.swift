//
//  MessageListEmptyView.swift
//  pochi
//
//  Created by akiho on 2017/02/08.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    @IBOutlet weak var messageLabel: UILabel!
    
    class func instance() -> EmptyView {
        return R.nib.emptyView.firstView(owner: nil, options: nil)!
    }
    
    func bind(data: DisplayData) {
        messageLabel.text = data.message
    }
    
    struct DisplayData {
        let message: String
    }
}
