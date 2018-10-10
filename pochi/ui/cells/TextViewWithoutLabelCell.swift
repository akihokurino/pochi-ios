//
//  TextViewWithoutLabelCell.swift
//  pochi
//
//  Created by akiho on 2017/05/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TextViewWithoutLabelCell: UITableViewCell {
    
    static let HEIGHT: Int = 160
    static let IDENTITY: String = R.reuseIdentifier.textViewWithoutLabelCell.identifier
    static let NIB: UINib = R.nib.textViewWithoutLabelCell()

    @IBOutlet weak var textView: UITextView!
    
    var observeInput: Driver<String?> {
        return self.textView.rx.text.asDriver()
    }
    
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
