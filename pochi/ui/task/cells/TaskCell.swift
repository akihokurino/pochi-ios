//
//  TaskCell.swift
//  pochi
//
//  Created by akiho on 2017/05/27.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    static let HEIGHT: Int = 59
    static let IDENTITY: String = R.reuseIdentifier.taskCell.identifier
    static let NIB: UINib = R.nib.taskCell()
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bind(task: UserTask) {
        self.titleLabel.text = task.title
        
        switch task.type {
        case .report:
            iconView.image = R.image.ic_camera()
        case .review:
            iconView.image = R.image.ic_review_star_fill()
        }
    }
}
