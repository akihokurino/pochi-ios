//
//  PickerTextFieldWithSectionCell.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PickerTextFieldWithSectionCell: UITableViewCell, InputCell {

    static let HEIGHT: Int = 96
    static let IDENTITY: String = R.reuseIdentifier.pickerTextFieldWithSectionCell.identifier
    static let NIB: UINib = R.nib.pickerTextFieldWithSectionCell()
    
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var pickerTextField: PickerTextField!
    
    private var inputDisposeBag: Disposable? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = UITableViewCellSelectionStyle.none
        pickerTextField.removeUnderline()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getInput() -> UITextInput {
        return self.pickerTextField
    }
    
    func sync(data: InputCellData) {
        sectionTitle.text = data.label
        pickerTextField.text = data.value.value
        pickerTextField.setup(dataList: data.selectItems ?? [])
        
        inputDisposeBag?.dispose()
        inputDisposeBag = pickerTextField.rx.text.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { text in
                data.value.value = text ?? data.value.value
            })
    }
}
