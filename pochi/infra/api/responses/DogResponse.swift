//
//  DogResponse.swift
//  pochi
//
//  Created by akiho on 2017/03/31.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DogResponse: ResponseJsonParsable {
    let id: Int64
    let name: String
    let age: Int
    let breed: String
    let gender: String
    let birthdate: String
    let size: String
    let isCastrated: Bool
    let createdAt: Int64
    let updatedAt: Int64
    let userId: String
    let iconUrl: String
    
    static func from(json: JSON!) -> DogResponse {
        return DogResponse(
            id: json["id"].int64Value,
            name: json["name"].stringValue,
            age: json["age"].intValue,
            breed: json["breed"].stringValue,
            gender: json["gender"].stringValue,
            birthdate: json["birthdate"].stringValue,
            size: json["size"].stringValue,
            isCastrated: json["isCastrated"].boolValue,
            createdAt: json["createdAt"].int64Value,
            updatedAt: json["updatedAt"].int64Value,
            userId: json["userId"].stringValue,
            iconUrl: json["iconUrl"].stringValue)
    }
    
    func to() -> Dog {
        return Dog(id: self.id,
                   name: self.name,
                   breed: self.breed,
                   gender: self.gender,
                   age: self.age,
                   birthdate: self.birthdate,
                   size: self.size,
                   isCastrated: self.isCastrated,
                   createdAt: self.createdAt,
                   updatedAt: self.updatedAt,
                   userId: self.userId,
                   iconUrl: self.iconUrl)
    }
}
