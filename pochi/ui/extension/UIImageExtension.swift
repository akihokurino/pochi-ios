//
//  UIImageExtension.swift
//  pochi
//
//  Created by akiho on 2017/07/23.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func toBase64Encode() -> String {
        let imageData: NSData = UIImagePNGRepresentation(
            resize(size: CGSize(width: 200, height: 200))
        )! as NSData
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio),
                                 height: (self.size.height * ratio))
        
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 2)
        draw(in: CGRect(x: 0,
                        y: 0,
                        width: resizedSize.width,
                        height: resizedSize.height))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
}
