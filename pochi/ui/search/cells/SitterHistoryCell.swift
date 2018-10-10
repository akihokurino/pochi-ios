//
//  SitterHistoryCell.swift
//  pochi
//
//  Created by akiho on 2017/02/21.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class SitterHistoryCell: UICollectionViewCell {
    
    static let IDENTITY: String = R.reuseIdentifier.sitterHistoryCell.identifier
    static let NIB: UINib = R.nib.sitterHistoryCell()
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(sitter: Sitter) {
        userIconView.load(url: URL(string: sitter.overview.iconUri)!)
        titleLabel.text = sitter.overview.nickname
    }
}
