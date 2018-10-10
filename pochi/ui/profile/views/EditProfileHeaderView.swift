//
//  EditProfileHeaderView.swift
//  pochi
//
//  Created by akiho on 2017/02/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditProfileHeaderView: UIView {
    
    private static let HEIGHT: Int = 186

    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var editBtn: UIButton!
    
    var observeEditBtn: Driver<Void> {
        return editBtn.rx.tap.asDriver()
    }
    
    class func instance() -> EditProfileHeaderView {
        let view = R.nib.editProfileHeaderView.firstView(owner: nil, options: nil)!
        
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: Int(UIScreen.main.bounds.width),
            height: EditProfileHeaderView.HEIGHT)
        
        return view
    }
    
    func setIcon(image: UIImage) {
        userIconView.image = image
    }
    
    func setIcon(url: URL) {
        userIconView.load(url: url)
    }
}
