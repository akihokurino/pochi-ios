//
//  FooterLinkView.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FooterLinkView: UIView {
    
    @IBOutlet weak var linkBtn: UIButton!
    
    var observeLinkbtn: Driver<Void> {
        return linkBtn.rx.tap.asDriver()
    }
    
    class func instance() -> FooterLinkView {
        return R.nib.footerLinkView.firstView(owner: nil, options: nil)!
    }
    
    func setup(title: String) {
        linkBtn.setTitle(title, for: .normal)
    }
}
