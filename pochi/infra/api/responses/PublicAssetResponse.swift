//
//  PublicAssetResponse.swift
//  pochi
//
//  Created by akiho on 2017/03/25.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PublicAssetResponse: ResponseJsonParsable {
    let dogBreedTypes: [AssetResponse]
    let dogGenderTypes: [AssetResponse]
    let dogAttributes: [AssetResponse]
    let dogSizeTypes: [AssetResponse]
    let dogKeepingStyles: [AssetResponse]
    let houseTypes: [AssetResponse]
    let kidsTypes: [AssetResponse]
    let options: [AssetResponse]
    let smokingPolicies: [AssetResponse]
    let walkingPolicies: [AssetResponse]
    
    static func from(json: JSON!) -> PublicAssetResponse {
        let masterDataJson: [String: JSON] = json["masterData"].dictionaryValue
        
        return PublicAssetResponse(
            dogBreedTypes: masterDataJson["dogBreedTypes"]!.arrayValue.map { AssetResponse.from(json: $0) },
            dogGenderTypes: masterDataJson["dogGenderTypes"]!.arrayValue.map { AssetResponse.from(json: $0) },
            dogAttributes: masterDataJson["dogAttributes"]!.arrayValue.map { AssetResponse.from(json: $0) },
            dogSizeTypes: masterDataJson["dogSizeTypes"]!.arrayValue.map { AssetResponse.from(json: $0) },
            dogKeepingStyles: masterDataJson["dogKeepingStyles"]!.arrayValue.map { AssetResponse.from(json: $0) },
            houseTypes: masterDataJson["houseTypes"]!.arrayValue.map { AssetResponse.from(json: $0) },
            kidsTypes: masterDataJson["kidsTypes"]!.arrayValue.map { AssetResponse.from(json: $0) },
            options: masterDataJson["stayOptions"]!.arrayValue.map { AssetResponse.from(json: $0) },
            smokingPolicies: masterDataJson["smokingPolicies"]!.arrayValue.map { AssetResponse.from(json: $0) },
            walkingPolicies: masterDataJson["walkingPolicies"]!.arrayValue.map { AssetResponse.from(json: $0) })
    }
}
