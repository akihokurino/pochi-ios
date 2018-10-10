//
//  AssetResponse.swift
//  pochi
//
//  Created by akiho on 2017/03/25.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AssetResponse: ResponseJsonParsable {
    let label: String
    let value: String
    
    static func from(json: JSON!) -> AssetResponse {
        return AssetResponse(
            label: json["label"].stringValue,
            value: json["value"].stringValue
        )
    }
    
    func to() -> PublicAssetRepository.Asset {
        return PublicAssetRepository.Asset(label: self.label, value: self.value)
    }
}
