//
//  FooterBtnWithLinkView.swift
//  pochi
//
//  Created by akiho on 2017/03/01.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FooterBtnWithLinkView: UIView {
    
    enum BtnState {
        case InActive
        case Active
    }
    
    private static let HEIGHT: Int = 152

    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var linkBtn: UIButton!
    
    var observeBtn: Driver<Void> {
        return btn.rx.tap.asDriver()
    }
    
    var observeLink: Driver<Void> {
        return linkBtn.rx.tap.asDriver()
    }
    
    class func instance(btnTitle: String, linkTitle: String) -> FooterBtnWithLinkView {
        let view = R.nib.footerBtnWithLinkView.firstView(owner: nil, options: nil)!
        
        view.setBtnState(state: .InActive)
        
        view.btn.setTitle(btnTitle, for: .normal)
        view.linkBtn.setTitle(linkTitle, for: .normal)
        
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: Int(UIScreen.main.bounds.width),
            height: FooterBtnWithLinkView.HEIGHT)
        
        return view
    }
    
    func setBtnState(state: BtnState) {
        switch state {
        case .Active:
            btn.backgroundColor = UIColor.activeColor()
            btn.isEnabled = true
        case .InActive:
            btn.backgroundColor = UIColor.inActiveColor()
            btn.isEnabled = false
        }
    }
}
