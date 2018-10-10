//
//  TextFieldWithoutLabelCell.swift
//  pochi
//
//  Created by akiho on 2017/06/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TextFieldWithoutLabelCell: UITableViewCell {
    
    static let HEIGHT: Int = 48
    static let IDENTITY: String = R.reuseIdentifier.textFieldWithoutLabelCell.identifier
    static let NIB: UINib = R.nib.textFieldWithoutLabelCell()
    
    var disposable: Disposable?

    @IBOutlet weak var textField: UITextField!
    
    var observeInput: Driver<String?> {
        return self.textField.rx.text.asDriver()
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
    
    func bind(placeholder: String) {
        textField.placeholder = placeholder
    }
}
