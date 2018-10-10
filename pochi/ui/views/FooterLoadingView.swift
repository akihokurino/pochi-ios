//
//  FooterLoadingView.swift
//  pochi
//
//  Created by akiho on 2017/10/09.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class FooterLoadingView: UIView {
    
    private static let HEIGHT = 60

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    class func instance() -> FooterLoadingView {
        let view = R.nib.footerLoadingView.firstView(owner: nil, options: nil)!
    
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: Int(UIScreen.main.bounds.width),
            height: FooterLoadingView.HEIGHT)
        
        view.indicator.startAnimating()
        
        return view
    }

}
