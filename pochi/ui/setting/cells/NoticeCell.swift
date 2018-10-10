//
//  NoticeCell.swift
//  pochi
//
//  Created by akiho on 2017/02/08.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {
    
    static let HEIGHT: Int = 68
    static let IDENTITY: String = R.reuseIdentifier.noticeCell.identifier
    static let NIB: UINib = R.nib.noticeCell()
    
    @IBOutlet weak var titleLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addSubview(createBorder())
        accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func createBorder() -> UIView {
        let borderView = UIView(frame: CGRect(
            x: 0,
            y: NoticeCell.HEIGHT - 1,
            width: Int(UIScreen.main.bounds.width),
            height: 1
        ))
        borderView.backgroundColor = UIColor.inActiveColor()
        
        return borderView
    }
}
