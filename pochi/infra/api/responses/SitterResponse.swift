//
//  SitterResponse.swift
//  pochi
//
//  Created by akiho on 2017/07/12.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SitterResponse: ResponseJsonParsable {
    let user: UserResponse
    let activated: Bool
    let introductionMessage: String
    let acceptableDogSizes: [String]
    let houseType: String
    let smokingPolicy: String
    let kidsTypes: [String]
    let serviceDescription: String
    let dogKeepingStyle: String
    let walkingPolicy: String
    let acceptableDogTypes: [String]
    let unacceptableDogTypes: [String]
    let options: [String]
    let geoHexCode: String
    let createdAt: Int64
    let updatedAt: Int64
    let scoreAverage: Double
    let address: AddressResponse?
    let mainImage: String
    let interiorImages: [ImageResponse]
    
    static func from(json: JSON!) -> SitterResponse {
        return SitterResponse(user: UserResponse.from(json: json["user"]),
                              activated: json["activated"].boolValue,
                              introductionMessage: json["introductionMessage"].stringValue,
                              acceptableDogSizes: json["acceptableDogSizes"].arrayValue.map({ $0.stringValue }),
                              houseType: json["houseType"].stringValue,
                              smokingPolicy: json["smokingPolicy"].stringValue,
                              kidsTypes: json["kidsTypes"].arrayValue.map({ $0.stringValue }),
                              serviceDescription: json["serviceDescription"].stringValue,
                              dogKeepingStyle: json["dogKeepingStyle"].stringValue,
                              walkingPolicy: json["walkingPolicy"].stringValue,
                              acceptableDogTypes: json["acceptableDogTypes"].arrayValue.map({ $0.stringValue }),
                              unacceptableDogTypes: json["unacceptableDogTypes"].arrayValue.map({ $0.stringValue }),
                              options: json["options"].arrayValue.map({ $0.stringValue }),
                              geoHexCode: json["geoHexCode"].stringValue,
                              createdAt: json["createdAt"].int64Value,
                              updatedAt: json["updatedAt"].int64Value,
                              scoreAverage: json["scoreAverage"].doubleValue,
                              address: !json["address"].isEmpty ? AddressResponse.from(json: json["address"]) : nil,
                              mainImage: json["mainImage"].stringValue,
                              interiorImages: json["interiorImages"].arrayValue.map({ ImageResponse.from(json: $0) }))
    }
    
    func to() -> Sitter {
        return Sitter(activated: self.activated,
                      introductionMessage: self.introductionMessage,
                      rawAcceptableDogSizes: self.acceptableDogSizes,
                      rawHouseType: self.houseType,
                      rawSmokingPolicy: self.smokingPolicy,
                      rawKidsTypes: self.kidsTypes,
                      serviceDescription: self.serviceDescription,
                      rawDogKeepingStyle: self.dogKeepingStyle,
                      rawWalkingPolicy: self.walkingPolicy,
                      rawAcceptableDogTypes: self.acceptableDogTypes,
                      rawUnacceptableDogTypes: self.unacceptableDogTypes,
                      rawOptions: self.options,
                      geoHexCode: self.geoHexCode,
                      createdAt: self.createdAt,
                      updatedAt: self.updatedAt,
                      scoreAverage: self.scoreAverage,
                      id: self.user.id,
                      firstName: self.user.firstName,
                      lastName: self.user.lastName,
                      nickname: self.user.nickname,
                      iconUri: self.user.iconUri,
                      address: self.address?.to(),
                      mainImage: self.mainImage,
                      interiorImages: self.interiorImages.map({ $0.to() }),
                      point: self.user.point)
    }
}
