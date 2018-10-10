//
//  UIImageViewExtension.swift
//  pochi
//
//  Created by akiho on 2017/07/21.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage
import PINCache

extension UIImageView {
    func load(url: URL) {
        pin_setImage(from: url)
        // PINCache.shared().setObject(image!, forKey: url.absoluteString)
    }
}
