//
//  MyMessageImageCell.swift
//  pochi
//
//  Created by akiho on 2017/07/23.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class MyMessageImageCell: UITableViewCell {

    static let IDENTITY: String = R.reuseIdentifier.myMessageImageCell.identifier
    static let NIB: UINib = R.nib.myMessageImageCell()
    
    @IBOutlet weak var contentImageView: UIImageView!
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
        contentImageView.load(url: URL(string: message.imageUri!)!)
        if let at = message.createdAt {
            dateLabel.text = DateDelegate.timestampToDateString(timestamp: at)
        } else {
            dateLabel.text = DateDelegate.dateToDateString(date: Date())
        }
    }
}
