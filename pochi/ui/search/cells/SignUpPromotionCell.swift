//
//  SignUpPromotionCell.swift
//  pochi
//
//  Created by akiho on 2017/06/09.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpPromotionCell: UITableViewCell {
    
    static let IDENTITY: String = R.reuseIdentifier.signUpPromotionCell.identifier
    static let NIB: UINib = R.nib.signUpPromotionCell()

    @IBOutlet weak var bannerView: UIImageView!
    
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
