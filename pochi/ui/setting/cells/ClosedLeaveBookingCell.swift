//
//  ClosedLeaveBookingCell.swift
//  pochi
//
//  Created by akiho on 2017/06/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class ClosedLeaveBookingCell: UITableViewCell {
    
    static let HEIGHT: Int = 138
    static let IDENTITY: String = R.reuseIdentifier.closedLeaveBookingCell.identifier
    static let NIB: UINib = R.nib.closedLeaveBookingCell()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!

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
        userLabel.text = booking.sitter.nickname
        costLabel.text = "\(booking.totalPrice)"
    }
}
