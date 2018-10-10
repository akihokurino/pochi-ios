//
//  UploadPhotoCell.swift
//  pochi
//
//  Created by akiho on 2017/05/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UploadPhotoCell: UITableViewCell {
    
    static let HEIGHT: Int = 224
    static let IDENTITY: String = R.reuseIdentifier.uploadPhotoCell.identifier
    static let NIB: UINib = R.nib.uploadPhotoCell()
    
    @IBOutlet weak var uploadBtn: UIImageView!
    @IBOutlet weak var uploadImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(image: UIImage) {
        uploadImageView.image = image
    }
}
