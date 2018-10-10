//
//  SearchHeaderView.swift
//  pochi
//
//  Created by akiho on 2017/03/05.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchHeaderView: UIView {
    static let HEIGHT = 195
    
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    var observeSearchBtn: Driver<Void> {
        return searchBtn.rx.tap.asDriver()
    }
    
    var observeSearchText: Driver<String?> {
        return postalCodeTextField.rx.text.asDriver()
    }
    
    class func instance() -> SearchHeaderView {
        let view = R.nib.searchHeaderView.firstView(owner: nil, options: nil)!
        
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: Int(UIScreen.main.bounds.width),
            height: SearchHeaderView.HEIGHT)
        
        return view
    }
}
