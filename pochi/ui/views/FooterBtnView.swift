//
//  FooterBtnView.swift
//  pochi
//
//  Created by akiho on 2017/03/01.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FooterBtnView: UIView {
    
    enum BtnState {
        case inActive
        case active
    }
    
    private static let HEIGHT: Int = 96
    
    @IBOutlet weak var btn: UIButton!
    
    var observeBtn: Driver<Void> {
        return btn.rx.tap.asDriver()
    }
    
    class func instance() -> FooterBtnView {
        let view = R.nib.footerBtnView.firstView(owner: nil, options: nil)!
        
        view.setBtnState(state: .inActive)
        
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: Int(UIScreen.main.bounds.width),
            height: FooterBtnView.HEIGHT)
        
        return view
    }
    
    func setBtnTitle(title: String) {
        self.btn.setTitle(title, for: .normal)
    }
    
    func setBtnState(state: BtnState) {
        switch state {
        case .active:
            btn.backgroundColor = UIColor.activeColor()
            btn.isEnabled = true
        case .inActive:
            btn.backgroundColor = UIColor.inActiveColor()
            btn.isEnabled = false
        }
    }
}
