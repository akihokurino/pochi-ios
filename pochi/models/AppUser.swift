//
//  AppUser.swift
//  pochi
//
//  Created by Akiho on 2016/12/04.
//  Copyright © 2016年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class AppUser: User {
    
    struct FireAuth {
        let uid: String
        let email: String
        let token: String
    }
    
    let uid: String
    let email: String
    let isNotificationOptedIn: Bool
        
    init(uid: String,
         email: String,
         id: String,
         firstName: String,
         lastName: String,
         nickname: String,
         iconUri: String,
         introductionMessage: String,
         createdAt: Int64,
         updatedAt: Int64,
         roles: [Role],
         point: Int64,
         scoreAverage: Double,
         isNotificationOptedIn: Bool) {
        
        self.uid = uid
        self.email = email
        self.isNotificationOptedIn = isNotificationOptedIn
        
        super.init(id: id,
                   firstName: firstName,
                   lastName: lastName,
                   nickname: nickname,
                   iconUri: iconUri,
                   introductionMessage: introductionMessage,
                   createdAt: createdAt,
                   updatedAt: updatedAt,
                   roles: roles,
                   point: point,
                   scoreAverage: scoreAverage)
    }
    
    func updateEmail(newEmail: String) -> AppUser {
        return AppUser(uid: self.uid,
                       email: newEmail,
                       id: self.overview.id,
                       firstName: self.overview.firstName,
                       lastName: self.overview.lastName,
                       nickname: self.overview.nickname,
                       iconUri: self.overview.iconUri,
                       introductionMessage: self.introductionMessage,
                       createdAt: self.createdAt,
                       updatedAt: self.updatedAt,
                       roles: self.roles,
                       point: self.point,
                       scoreAverage: self.scoreAverage,
                       isNotificationOptedIn: self.isNotificationOptedIn)
    }
    
    func updateUser(user: User) -> AppUser {
        return AppUser(uid: self.uid,
                       email: self.email,
                       id: user.overview.id,
                       firstName: user.overview.firstName,
                       lastName: user.overview.lastName,
                       nickname: user.overview.nickname,
                       iconUri: user.overview.iconUri,
                       introductionMessage: user.introductionMessage,
                       createdAt: user.createdAt,
                       updatedAt: user.updatedAt,
                       roles: user.roles,
                       point: user.point,
                       scoreAverage: user.scoreAverage,
                       isNotificationOptedIn: self.isNotificationOptedIn)
    }
}
