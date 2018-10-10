//
//  CreateUserResponse.swift
//  pochi
//
//  Created by akiho on 2017/03/31.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserResponse: ResponseJsonParsable {
    let id: String
    let firstName: String
    let lastName: String
    let nickname: String
    let iconUri: String
    let introductionMessage: String
    let createdAt: Int64
    let updatedAt: Int64
    let roles: [String]
    let isNotificationOptedIn: Bool
    let point: Int64
    let scoreAverage: Double
    
    static func from(json: JSON!) -> UserResponse {
        return UserResponse(
            id: json["id"].stringValue,
            firstName: json["firstName"].string ?? "",
            lastName: json["lastName"].string ?? "",
            nickname: json["nickname"].stringValue,
            iconUri: json["iconUri"].stringValue,
            introductionMessage: json["introductionMessage"].stringValue,
            createdAt: json["createdAt"].int64Value,
            updatedAt: json["updatedAt"].int64Value,
            roles: json["userRoles"].arrayValue.map({ $0.stringValue }),
            isNotificationOptedIn: json["isNotificationOptedIn"].boolValue,
            point: json["point"].int64Value,
            scoreAverage: json["scoreAverage"].doubleValue)
    }
    
    func to(fireAuth: AppUser.FireAuth) -> AppUser {
        return AppUser(uid: fireAuth.uid,
                       email: fireAuth.email,
                       id: self.id,
                       firstName: self.firstName,
                       lastName: self.lastName,
                       nickname: self.nickname,
                       iconUri: self.iconUri,
                       introductionMessage: self.introductionMessage,
                       createdAt: self.createdAt,
                       updatedAt: self.updatedAt,
                       roles: self.roles.map({ User.Role(rawValue: $0)! }),
                       point: self.point,
                       scoreAverage: self.scoreAverage,
                       isNotificationOptedIn: self.isNotificationOptedIn)
    }
    
    func to() -> User {
        return User(id: self.id,
                    firstName: self.firstName,
                    lastName: self.lastName,
                    nickname: self.nickname,
                    iconUri: self.iconUri,
                    introductionMessage: self.introductionMessage,
                    createdAt: self.createdAt,
                    updatedAt: self.updatedAt,
                    roles: self.roles.map({ User.Role(rawValue: $0)! }),
                    point: self.point,
                    scoreAverage: self.scoreAverage)
    }
}
