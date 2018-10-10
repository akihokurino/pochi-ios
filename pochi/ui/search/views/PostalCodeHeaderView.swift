//
//  PostalCodeHeaderView.swift
//  pochi
//
//  Created by akiho on 2017/02/22.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PostalCodeHeaderView: UIView {
    
    static let HEIGHT: Int = 54

    @IBOutlet weak var postalCodeLabel: UILabel!
    @IBOutlet weak var changeBtn: UIButton!
    
    var observeChangeBtn: Driver<Void> {
        return changeBtn.rx.tap.asDriver()
    }
    
    class func instance() -> PostalCodeHeaderView {
        let view = R.nib.postalCodeHeaderView.firstView(owner: nil, options: nil)!
        
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: Int(UIScreen.main.bounds.width),
            height: PostalCodeHeaderView.HEIGHT)
        
        return view
    }
}
