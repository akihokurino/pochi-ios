//
//  ReviewHeaderView.swift
//  pochi
//
//  Created by akiho on 2017/05/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class ReviewHeaderView: UIView {
    
    private static let HEIGHT: Int = 248

    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    class func instance() -> ReviewHeaderView {
        let view = R.nib.reviewHeaderView.firstView(owner: nil, options: nil)!
        
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: Int(UIScreen.main.bounds.width),
            height: ReviewHeaderView.HEIGHT)
        
        view.userNameLabel.text = ""
        view.dateLabel.text = ""
        
        return view
    }
    
    func bind(user: User, task: UserTask) {
        if !user.overview.iconUri.isEmpty {
            userIconView.load(url: URL(string: user.overview.iconUri)!)
        }
        
        userNameLabel.text = "\(user.overview.lastName) \(user.overview.firstName)"
        dateLabel.text = task.date
    }
}
