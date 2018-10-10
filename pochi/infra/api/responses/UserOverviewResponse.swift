//
//  UserOverviewResponse.swift
//  pochi
//
//  Created by Akiho Kurino on 2017/07/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserOverviewResponse: ResponseJsonParsable {
    let id: String
    let firstName: String
    let lastName: String
    let nickname: String
    let iconUri: String
    
    static func from(json: JSON!) -> UserOverviewResponse {
        return UserOverviewResponse(
            id: json["id"].stringValue,
            firstName: json["firstName"].string ?? "",
            lastName: json["lastName"].string ?? "",
            nickname: json["nickname"].stringValue,
            iconUri: json["iconUri"].stringValue)
    }
    
    func to() -> UserOverview {
        return UserOverview(id: self.id,
                            firstName: self.firstName,
                            lastName: self.lastName,
                            nickname: self.nickname,
                            iconUri: self.iconUri)
    }
}

