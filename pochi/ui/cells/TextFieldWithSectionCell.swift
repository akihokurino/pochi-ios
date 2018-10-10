//
//  TextFieldWithSectionCell.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TextFieldWithSectionCell: UITableViewCell, InputCell {
    
    static let HEIGHT: Int = 96
    static let IDENTITY: String = R.reuseIdentifier.textFieldWithSectionCell.identifier
    static let NIB: UINib = R.nib.textFieldWithSectionCell()
    private var inputDisposeBag: Disposable? = nil

    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getInput() -> UITextInput {
        return textField
    }
    
    func sync(data: InputCellData) {
        sectionTitle.text = data.label
        textField.text = data.value.value
        
        inputDisposeBag?.dispose()
        inputDisposeBag = textField.rx.text.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { text in
                data.value.value = text ?? data.value.value
            })
    }
}
