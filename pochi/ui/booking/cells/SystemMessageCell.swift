//
//  SystemMessageCell.swift
//  pochi
//
//  Created by akiho on 2017/08/25.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class SystemMessageCell: UITableViewCell {
    
    static let IDENTITY: String = R.reuseIdentifier.systemMessageCell.identifier
    static let NIB: UINib = R.nib.systemMessageCell()

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(message: Message) {
        contentLabel.text = message.content
    }
}
