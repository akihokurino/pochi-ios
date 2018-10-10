//
//  SitterHouseThumbnailDataSource.swift
//  pochi
//
//  Created by akiho on 2017/04/22.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SitterHouseThumbnailDataSource: NSObject, UICollectionViewDataSource, RxCollectionViewDataSourceType {
    
    typealias Element = [Image]
    fileprivate var items: Element = []
    
    fileprivate var selectItem: Variable<Image?> = Variable(nil)
    private let collectionView: UICollectionView
    
    var observeSelectItem: Driver<Image?> {
        return selectItem.asDriver()
    }
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
        
        super.init()
        
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<[Image]>) {
        if case .next(let items) = observedEvent {
            self.items = items
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as UICollectionViewCell
        
        let imageView = UIImageView(frame: cell.contentView.bounds)
        imageView.load(url: URL(string: self.items[indexPath.row].image)!)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        cell.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
}

extension SitterHouseThumbnailDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectItem.value = self.items[indexPath.row]
    }
}
