//
//  BookingCell.swift
//  pochi
//
//  Created by akiho on 2017/02/08.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class BookingCell: UITableViewCell {
    
    static let HEIGHT: Int = 138
    static let IDENTITY: String = R.reuseIdentifier.bookingCell.identifier
    static let NIB: UINib = R.nib.bookingCell()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
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
        let appUser = AppUserStore.shared.restore()!
        
        switch appUser.overview.id {
        case booking.user.id:
            userIconView.load(url: URL(string: booking.sitter.iconUri)!)
            userNameLabel.text = "\(booking.sitter.lastName) \(booking.sitter.firstName)"
        case booking.sitter.id:
            userIconView.load(url: URL(string: booking.user.iconUri)!)
            userNameLabel.text = "\(booking.user.lastName) \(booking.user.firstName)"
        default:
            // TODO: エラー処理
            break
        }
        
        if booking.message == nil {
            messageLabel.text = "やりとりはありません"
        } else {
            messageLabel.text = booking.message!.imageUri != nil ? "画像が送信されました" : booking.message!.content
        }
        
        lastUpdatedLabel.text = DateDelegate.timestampToDateString(timestamp: booking.updatedAt)
        
        if booking.startDate != nil && booking.endDate != nil {
            dateLabel.text = "\(booking.startDate!) - \(booking.endDate!)"
        } else {
            dateLabel.text = "日程：未定"
        }
    }
}
