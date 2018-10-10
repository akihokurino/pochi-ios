//
//  HostDetailFooterView.swift
//  pochi
//
//  Created by akiho on 2017/02/26.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MessageLinkView: UIView {
    
    private static let HEIGHT: Int = 48
    
    @IBOutlet weak var messageBtn: UIButton!
    
    var observeMessageBtn: Driver<Void> {
        return messageBtn.rx.tap.asDriver()
    }
    
    class func instance() -> MessageLinkView {
        let view = R.nib.messageLinkView.firstView(owner: nil, options: nil)!
        
        view.frame = CGRect(
            x: 0,
            y: Int(UIScreen.main.bounds.height) - MessageLinkView.HEIGHT,
            width: Int(UIScreen.main.bounds.width),
            height: MessageLinkView.HEIGHT)
        
        return view
    }
}
