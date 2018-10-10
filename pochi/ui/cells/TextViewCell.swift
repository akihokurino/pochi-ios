//
//  TextViewCell.swift
//  pochi
//
//  Created by akiho on 2017/02/06.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TextViewCell: UITableViewCell, InputCell {
    
    static let HEIGHT: Int = 180
    static let IDENTITY: String = R.reuseIdentifier.textViewCell.identifier
    static let NIB: UINib = R.nib.textViewCell()
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textView: UnderLineTextView!
    
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
        return self.textView
    }
    
    func sync(data: InputCellData) {
        self.label.text = data.label
        self.textView.text = data.value.value
        
        inputDisposeBag?.dispose()
        inputDisposeBag = textView.rx.text.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { text in
                data.value.value = text ?? data.value.value
            })
    }
}
