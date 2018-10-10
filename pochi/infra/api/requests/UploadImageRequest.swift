//
//  UploadImageRequest.swift
//  pochi
//
//  Created by akiho on 2017/08/25.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import Moya

struct UploadImageRequest {
    
    enum ImageFormat {
        case jpeg
        case png
        
        var mimeType: String {
            switch self {
            case .jpeg:
                return "image/jpeg"
            case .png:
                return "image/png"
            }
        }
        
        func getImageData(image: UIImage) -> Data {
            switch self {
            case .jpeg:
                return UIImageJPEGRepresentation(image, 1.0)!
            case .png:
                return UIImagePNGRepresentation(image)!
            }
        }
    }
    
    let image: UIImage
    let format: ImageFormat
    
    var getMultipartFormData: MultipartFormData {
        let fileName: String = {
            var returnStr = ""
            for _ in 0..<16 {
                returnStr += "\(arc4random_uniform(10))"
            }
            return returnStr
        }()
        let imageData: Data = format.getImageData(image: image)
        return MultipartFormData(provider: .data(imageData), name: "image", fileName: fileName, mimeType: format.mimeType)
    }
}
