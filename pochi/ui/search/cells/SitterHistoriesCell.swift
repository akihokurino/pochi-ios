//
//  SitterHistoriesCell.swift
//  pochi
//
//  Created by akiho on 2017/03/05.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift

class SitterHistoriesCell: UITableViewCell {
    
    static let IDENTITY: String = R.reuseIdentifier.sitterHistoriesCell.identifier
    static let NIB: UINib = R.nib.sitterHistoriesCell()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private(set) var selectItem: Variable<Sitter?> = Variable(nil)
    
    private var disposable: Disposable? = nil
    private var dataSource: SitterHistoryDataSource!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dataSource = SitterHistoryDataSource(collectionView: collectionView)
        
        collectionView.contentInset = UIEdgeInsetsMake(5, 0, 5, 0)
        
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(items: [Sitter]) {
        self.disposable?.dispose()
        self.disposable = dataSource.observeSelectItem.asObservable().bindTo(selectItem)
        
        dataSource.bind(items: items)
    }
}
