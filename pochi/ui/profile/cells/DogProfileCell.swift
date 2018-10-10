//
//  DogProfileCell.swift
//  pochi
//
//  Created by akiho on 2017/06/16.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DogProfileCell: UITableViewCell {
    
    static let HEIGHT: Int = 311
    static let IDENTITY: String = R.reuseIdentifier.dogProfileCell.identifier
    static let NIB: UINib = R.nib.dogProfileCell()

    @IBOutlet weak var dogIconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var castratedLabel: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    var disposable: Disposable? = nil
    
    var observeEditBtn: Driver<Void> {
        return editProfileBtn.rx.tap.asDriver()
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
    
    func bind(dog: Dog) {
        if !dog.iconUrl.isEmpty {
            dogIconView.load(url: URL(string: dog.iconUrl)!)
        }
        
        let breedName = PublicAssetRepository.shared.dogBreedTypes.first(where: { $0.value == dog.breed})!.label
        let genderName = PublicAssetRepository.shared.dogGenderTypes.first(where: { $0.value == dog.gender})!.label
        self.nameLabel.text = dog.name
        self.descriptionLabel.text = "\(breedName)/\(genderName)/\(dog.age)才"
        self.castratedLabel.text = "去勢：\(dog.isCastrated ? "あり" : "なし")"
    }
}
