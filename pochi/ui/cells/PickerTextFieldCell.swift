//
//  PickerTextFieldCell.swift
//  pochi
//
//  Created by akiho on 2017/02/05.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PickerTextFieldCell: UITableViewCell, InputCell {
    
    static let HEIGHT: Int = 90
    static let IDENTITY: String = R.reuseIdentifier.pickerTextFieldCell.identifier
    static let NIB: UINib = R.nib.pickerTextFieldCell()

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: PickerTextField!
    
    private var inputDisposeBag: Disposable? = nil
    
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
        return self.textField
    }
    
    func sync(data: InputCellData) {
        self.label.text = data.label
        self.textField.text = data.value.value
        textField.setup(dataList: data.selectItems!, isWriteOnce: data.isWriteOnce)
        
        inputDisposeBag?.dispose()
        inputDisposeBag = textField.rx.text.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { text in
                data.value.value = text ?? data.value.value
            })
    }
}
