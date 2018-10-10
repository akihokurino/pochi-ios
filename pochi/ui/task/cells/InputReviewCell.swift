//
//  ReviewCell.swift
//  pochi
//
//  Created by akiho on 2017/05/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class InputReviewCell: UITableViewCell {
    
    static let HEIGHT: Int = 48
    static let IDENTITY: String = R.reuseIdentifier.inputReviewCell.identifier
    static let NIB: UINib = R.nib.inputReviewCell()

    @IBOutlet weak var reviewContainer: UIView!
    private var reviewScoreView: ReviewScoreView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = UITableViewCellSelectionStyle.none
        
        reviewScoreView = ReviewScoreView.instance()
        reviewContainer.addSubview(reviewScoreView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(score: Double) {
        reviewScoreView.setup(score: score)
    }
}
