//
//  User.swift
//  pochi
//
//  Created by akiho on 2017/03/31.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation

class User {
    enum Role: String {
        case host = "HOST"
        case user = "USER"
    }
    
    let overview: UserOverview
    let introductionMessage: String
    let createdAt: Int64
    let updatedAt: Int64
    let roles: [Role]
    let point: Int64
    let scoreAverage: Double
    
    var isAppUser: Bool {
        guard let appUser = AppUserStore.shared.restore() else {
            return false
        }
        
        return appUser.overview.id == overview.id
    }
    
    var isSitter: Bool {
        return roles.contains(.host)
    }
    
    init(id: String,
         firstName: String,
         lastName: String,
         nickname: String,
         iconUri: String,
         introductionMessage: String,
         createdAt: Int64,
         updatedAt: Int64,
         roles: [Role],
         point: Int64,
         scoreAverage: Double) {
        self.overview = UserOverview(id: id,
                                     firstName: firstName,
                                     lastName: lastName,
                                     nickname: nickname,
                                     iconUri: iconUri)
        self.introductionMessage = introductionMessage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.roles = roles
        self.point = point
        self.scoreAverage = scoreAverage
    }
}
