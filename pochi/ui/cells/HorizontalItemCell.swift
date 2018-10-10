//
//  ReserveItemCell.swift
//  pochi
//
//  Created by akiho on 2017/01/21.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class HorizontalItemCell: UITableViewCell {
    
    static let HEIGHT: Int = 44
    static let IDENTITY: String = R.reuseIdentifier.horizontalItemCell.identifier
    static let NIB: UINib = R.nib.horizontalItemCell()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var bottomBorderRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBorderLeftConstraint: NSLayoutConstraint!
    
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
        self.titleLabel.text = data.title
        self.valueLabel.text = data.value
    }
    
    func withFullWidthBottomBorder() {
        bottomBorderLeftConstraint.constant = 0
        bottomBorderRightConstraint.constant = 0
    }
    
    func withMiddleWidthBottomBorder() {
        bottomBorderLeftConstraint.constant = 16
        bottomBorderRightConstraint.constant = 16
    }
    
    struct DisplayData {
        let title: String
        let value: String
    }
}
