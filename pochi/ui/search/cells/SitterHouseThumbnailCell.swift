//
//  SitterHouseThumbnailCell.swift
//  pochi
//
//  Created by akiho on 2017/01/26.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SitterHouseThumbnailCell: UITableViewCell {
    
    static let HEIGHT: Int = 112
    static let IDENTITY: String = R.reuseIdentifier.sitterHouseThumbnailCell.identifier
    static let NIB: UINib = R.nib.sitterHouseThumbnailCell()

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource: SitterHouseThumbnailDataSource!
    private var disposable: Disposable? = nil
    
    var observeSelectPhoto: Driver<Image?> {
        return dataSource.observeSelectItem
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addSubview(createBorder())
        selectionStyle = UITableViewCellSelectionStyle.none
        
        dataSource = SitterHouseThumbnailDataSource(collectionView: self.collectionView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func createBorder() -> UIView {
        let borderView = UIView(frame: CGRect(
            x: 0,
            y: SitterHouseThumbnailCell.HEIGHT - 1,
            width: Int(UIScreen.main.bounds.width),
            height: 1
        ))
        borderView.backgroundColor = UIColor.inActiveColor()
        
        return borderView
    }
    
    func bind(images: Observable<[Image]>) {
        disposable?.dispose()
        disposable = images.bindTo(collectionView.rx.items(dataSource: dataSource))
    }
}
