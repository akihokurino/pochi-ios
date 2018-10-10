//
//  ReviewCell.swift
//  pochi
//
//  Created by akiho on 2017/01/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    
    static let IDENTITY: String = R.reuseIdentifier.reviewCell.identifier
    static let NIB: UINib = R.nib.reviewCell()
    
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var reviewScoreContainer: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bottomBorderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(review: Review) {
        userIconView.load(url: URL(string: review.reviewer.iconUri)!)
        nameLabel.text = "\(review.reviewer.lastName) \(review.reviewer.firstName)"
        nickNameLabel.text = review.reviewer.nickname
        contentLabel.text = review.content
        dateLabel.text = DateDelegate.timestampToDateString(timestamp: review.createdAt)
        let scoreView = ReviewScoreView.instance()
        scoreView.setup(score: Double(review.score))
        reviewScoreContainer.addSubview(scoreView)
    }
}
