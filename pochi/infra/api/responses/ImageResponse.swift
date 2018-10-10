//
//  ImageResponse.swift
//  pochi
//
//  Created by akiho on 2017/08/23.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ImageResponse: ResponseJsonParsable {
    let id: Int64
    let image: String
    static func from(json: JSON!) -> ImageResponse {
        return ImageResponse(id: json["id"].int64Value,
                             image: json["image"].stringValue)
    }
    
    func to() -> Image {
        return Image(id: self.id, image: self.image)
    }
}
