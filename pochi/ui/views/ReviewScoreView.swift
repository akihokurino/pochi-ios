//
//  ReviewScoreView.swift
//  pochi
//
//  Created by akiho on 2017/01/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class ReviewScoreView: UIView {
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var starImageView1: UIImageView!
    @IBOutlet weak var starImageView2: UIImageView!
    @IBOutlet weak var starImageView3: UIImageView!
    @IBOutlet weak var starImageView4: UIImageView!
    @IBOutlet weak var starImageView5: UIImageView!
    
    private var stars: [UIImageView] = []
    
    class func instance() -> ReviewScoreView {
        return R.nib.reviewScoreView.firstView(owner: nil, options: nil)!
    }
    
    func setup(score: Double) {
        // TODO: Outlet Collections で定義すると落ちる
        stars = [starImageView1, starImageView2, starImageView3, starImageView4, starImageView5]
        guard score <= Double(stars.count) else {
            return
        }
        
        stars.forEach {
            $0.image = R.image.ic_review_star()!
        }
        
        for i in 0..<Int(score) {
            stars[i].image = R.image.ic_review_star_fill()!
        }
        
        scoreLabel.text = "\(score)"
    }
}
