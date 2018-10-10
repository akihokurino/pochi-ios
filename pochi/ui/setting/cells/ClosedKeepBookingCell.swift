//
//  ClosedKeepBookingCell.swift
//  pochi
//
//  Created by akiho on 2017/06/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class ClosedKeepBookingCell: UITableViewCell {
    
    static let HEIGHT: Int = 187
    static let IDENTITY: String = R.reuseIdentifier.closedKeepBookingCell.identifier
    static let NIB: UINib = R.nib.closedKeepBookingCell()

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(booking: Booking) {
        if booking.startDate != nil && booking.endDate != nil {
            dateLabel.text = "\(booking.startDate!) 〜 \(booking.endDate!)"
        } else {
            dateLabel.text = "日付が選択されていません"
        }
        userLabel.text = booking.user.nickname
        costLabel.text = "\(booking.totalPrice)"
    }
}