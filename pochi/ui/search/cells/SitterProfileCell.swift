//
//  SitterProfileCell.swift
//  pochi
//
//  Created by akiho on 2017/02/26.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class SitterProfileCell: UITableViewCell {
    
    static let IDENTITY: String = R.reuseIdentifier.sitterProfileCell.identifier
    static let NIB: UINib = R.nib.sitterProfileCell()

    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
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
    
    func bind(sitter: Sitter) {
        userIconView.load(url: URL(string: sitter.overview.iconUri)!)
        userNameLabel.text = "\(sitter.overview.lastName) \(sitter.overview.firstName)"
        nickNameLabel.text = sitter.overview.nickname
        messageLabel.text = sitter.introductionMessage
    }
}
