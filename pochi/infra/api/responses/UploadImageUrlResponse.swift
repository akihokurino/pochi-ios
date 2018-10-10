//
//  UploadImageUrlResponse.swift
//  pochi
//
//  Created by akiho on 2017/08/25.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UploadImageUrlResponse: ResponseJsonParsable {
    let url: String
    
    static func from(json: JSON!) -> UploadImageUrlResponse {
        return UploadImageUrlResponse(url: json["url"].stringValue)
    }
}
