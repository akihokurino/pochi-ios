//
//  SearchTableDelegate.swift
//  pochi
//
//  Created by akiho on 2017/02/21.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit

class SearchTableDelegate: TableDelegate {
    static let IMAGE_HEADER_HEIGHT = 210
    
    func generateImageHeader(url: URL) -> UIView {
        let imageView = UIImageView(frame: CGRect(
            x: 0,
            y: 0,
            width: Int(tableView?.bounds.size.width ?? 0),
            height: SearchTableDelegate.IMAGE_HEADER_HEIGHT
        ))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.load(url: url)
        return imageView
    }
}
