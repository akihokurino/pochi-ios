//
//  NoticeDetailCell.swift
//  pochi
//
//  Created by akiho on 2017/02/08.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class NoticeDetailCell: UITableViewCell {
    
    static let IDENTITY: String = R.reuseIdentifier.noticeDetailCell.identifier
    static let NIB: UINib = R.nib.noticeDetailCell()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
