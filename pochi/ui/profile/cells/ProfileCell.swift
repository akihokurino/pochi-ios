//
//  ProfileCell.swift
//  pochi
//
//  Created by akiho on 2017/01/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    static let IDENTITY: String = R.reuseIdentifier.profileCell.identifier
    static let NIB: UINib = R.nib.profileCell()

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
    
    func bind(user: User?) {
        self.contentLabel.text = user?.introductionMessage ?? ""
    }
}
