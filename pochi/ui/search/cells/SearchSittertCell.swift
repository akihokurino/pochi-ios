//
//  SearchSitterCell.swift
//  pochi
//
//  Created by akiho on 2017/02/20.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class SearchSitterCell: UITableViewCell {
    
    static let IDENTITY: String = R.reuseIdentifier.searchSitterCell.identifier
    static let NIB: UINib = R.nib.searchSitterCell()
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewContainer: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sizeCapacityLabel: UILabel!
    
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
    
    func bind(sitter: Sitter) {
        thumbnailView.load(url: URL(string: sitter.mainImage)!)
        reviewScoreView.setup(score: sitter.scoreAverage)
        
        userIconView.load(url: URL(string: sitter.overview.iconUri)!)
        titleLabel.text = sitter.overview.nickname
        
        descriptionLabel.text = sitter.introductionMessage
        let isOkSmallSize: Bool = sitter.acceptableDogSizes.first(where: { $0 == Sitter.DogSizeType.small}) != nil
        let isOkMediumSize: Bool = sitter.acceptableDogSizes.first(where: { $0 == Sitter.DogSizeType.medium}) != nil
        let isOkLargeSize: Bool = sitter.acceptableDogSizes.first(where: { $0 == Sitter.DogSizeType.large}) != nil
        sizeCapacityLabel.text = "小型犬：\(isOkSmallSize ? "OK" : "NG")  /  中型犬：\(isOkMediumSize ? "OK" : "NG")  /  大型犬：\(isOkLargeSize ? "OK" : "NG")"
    }
}
