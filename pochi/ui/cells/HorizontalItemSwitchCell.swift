//
//  HorizontalItemSwitchCell.swift
//  pochi
//
//  Created by akiho on 2017/06/05.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HorizontalItemSwitchCell: UITableViewCell {
    
    static let HEIGHT: Int = 48
    static let IDENTITY: String = R.reuseIdentifier.horizontalItemSwitchCell.identifier
    static let NIB: UINib = R.nib.horizontalItemSwitchCell()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
