//
//  YourMessageCell.swift
//  pochi
//
//  Created by akiho on 2017/02/14.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class YourMessageCell: UITableViewCell {
    
    static let IDENTITY: String = R.reuseIdentifier.yourMessageCell.identifier
    static let NIB: UINib = R.nib.yourMessageCell()

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(message: Message) {
        self.contentLabel.text = message.content
        if let at = message.createdAt {
            dateLabel.text = DateDelegate.timestampToDateString(timestamp: at)
        } else {
            dateLabel.text = DateDelegate.dateToDateString(date: Date())
        }
        
        iconView.load(url: URL(string: message.from.iconUri)!)
    }
}
