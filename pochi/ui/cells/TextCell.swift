//
//  TextCell.swift
//  pochi
//
//  Created by akiho on 2017/06/10.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {
    
    static let IDENTITY: String = R.reuseIdentifier.textCell.identifier
    static let NIB: UINib = R.nib.textCell()

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
    
    func bind(data: DisplayData) {
        contentLabel.text = data.text
    }
    
    struct DisplayData {
        let text: String
    }
}
