//
//  MyProfileHeaderView.swift
//  pochi
//
//  Created by akiho on 2017/01/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {
    
    private static let HEIGHT: Int = 250

    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    class func instance() -> ProfileHeaderView {
        let view = R.nib.profileHeaderView.firstView(owner: nil, options: nil)!
        
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: Int(UIScreen.main.bounds.width),
            height: ProfileHeaderView.HEIGHT)
        
        return view

    }
    
    func bind(user: User) {
        if !user.overview.iconUri.isEmpty {
            userIconView.load(url: URL(string: user.overview.iconUri)!)
        }
        self.nameLabel.text = "\(user.overview.lastName) \(user.overview.firstName)"
        self.nickNameLabel.text = user.overview.nickname
    }
}
