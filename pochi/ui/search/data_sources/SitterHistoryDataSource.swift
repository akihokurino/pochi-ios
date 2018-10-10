//
//  HostHistoryDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/22.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SitterHistoryDataSource: NSObject, UICollectionViewDataSource {
    
    fileprivate var items: [Sitter] = []
    
    private let collectionView: UICollectionView
    fileprivate let selectItem: Variable<Sitter?> = Variable(nil)
    
    var observeSelectItem: Driver<Sitter?> {
        return selectItem.asDriver()
    }
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        self.collectionView.register(SitterHistoryCell.NIB, forCellWithReuseIdentifier: SitterHistoryCell.IDENTITY)
        
        super.init()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SitterHistoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SitterHistoryCell.IDENTITY, for: indexPath as IndexPath) as! SitterHistoryCell
        cell.bind(sitter: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func bind(items: [Sitter]) {
        self.items = items
        self.collectionView.reloadData()
    }
}

extension SitterHistoryDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectItem.value = self.items[0]
    }
}
