//
//  AppUserStoreData.swift
//  pochi
//
//  Created by akiho on 2017/04/01.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation

class AppUserStoreData: NSObject, NSCoding {
    struct SerializedKey {
        static let uid = "uid"
        static let email = "email"
        static let id = "id"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let nickname = "nickname"
        static let iconUri = "icon_uri"
        static let introductionMessage = "introduction_message"
        static let createdAt = "created_at"
        static let updatedAt = "updated_at"
        static let roles = "roles"
        static let point = "point"
        static let scoreAverage = "scoreAverage"
        static let isNotificationOptedIn = "is_notification_opted_in"
    }
    
    let uid: String
    let email: String
    let id: String
    let firstName: String
    let lastName: String
    let nickname: String
    let iconUri: String
    let introductionMessage: String
    let createdAt: Int64
    let updatedAt: Int64
    let roles: [String]
    let point: Int64
    let scoreAverage: Double
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
         roles: [String],
         point: Int64,
         scoreAverage: Double,
         isNotificationOptedIn: Bool) {
        self.uid = uid
        self.email = email
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.nickname = nickname
        self.iconUri = iconUri
        self.introductionMessage = introductionMessage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.roles = roles
        self.point = point
        self.scoreAverage = scoreAverage
        self.isNotificationOptedIn = isNotificationOptedIn
    }
    
    static func from(user: AppUser) -> AppUserStoreData {
        return AppUserStoreData(uid: user.uid,
                                email: user.email,
                                id: user.overview.id,
                                firstName: user.overview.firstName,
                                lastName: user.overview.lastName,
                                nickname: user.overview.nickname,
                                iconUri: user.overview.iconUri,
                                introductionMessage: user.introductionMessage,
                                createdAt: user.createdAt,
                                updatedAt: user.updatedAt,
                                roles: user.roles.map({ $0.rawValue }),
                                point: user.point,
                                scoreAverage: user.scoreAverage,
                                isNotificationOptedIn: user.isNotificationOptedIn)
    }
    
    func to() -> AppUser {
        return AppUser(uid: self.uid,
                       email: self.email,
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
    
    required init?(coder aDecoder: NSCoder) {
        self.uid = aDecoder.decodeObject(forKey: SerializedKey.uid) as? String ?? ""
        self.email = aDecoder.decodeObject(forKey: SerializedKey.email) as? String ?? ""
        self.id = aDecoder.decodeObject(forKey: SerializedKey.id) as? String ?? ""
        self.firstName = aDecoder.decodeObject(forKey: SerializedKey.firstName) as? String ?? ""
        self.lastName = aDecoder.decodeObject(forKey: SerializedKey.lastName) as? String ?? ""
        self.nickname = aDecoder.decodeObject(forKey: SerializedKey.nickname) as? String ?? ""
        self.iconUri = aDecoder.decodeObject(forKey: SerializedKey.iconUri) as? String ?? ""
        self.introductionMessage = aDecoder.decodeObject(forKey: SerializedKey.introductionMessage) as? String ?? ""
        self.createdAt = aDecoder.decodeInt64(forKey: SerializedKey.createdAt)
        self.updatedAt = aDecoder.decodeInt64(forKey: SerializedKey.updatedAt)
        self.roles = aDecoder.decodeObject(forKey: SerializedKey.roles) as? [String] ?? []
        self.point = aDecoder.decodeInt64(forKey: SerializedKey.point)
        self.scoreAverage = aDecoder.decodeDouble(forKey: SerializedKey.scoreAverage)
        self.isNotificationOptedIn = aDecoder.decodeBool(forKey: SerializedKey.isNotificationOptedIn)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.uid, forKey: SerializedKey.uid)
        aCoder.encode(self.email, forKey: SerializedKey.email)
        aCoder.encode(self.id, forKey: SerializedKey.id)
        aCoder.encode(self.firstName, forKey: SerializedKey.firstName)
        aCoder.encode(self.lastName, forKey: SerializedKey.lastName)
        aCoder.encode(self.nickname, forKey: SerializedKey.nickname)
        aCoder.encode(self.iconUri, forKey: SerializedKey.iconUri)
        aCoder.encode(self.introductionMessage, forKey: SerializedKey.introductionMessage)
        aCoder.encode(self.createdAt, forKey: SerializedKey.createdAt)
        aCoder.encode(self.updatedAt, forKey: SerializedKey.updatedAt)
        aCoder.encode(self.roles, forKey: SerializedKey.roles)
        aCoder.encode(self.point, forKey: SerializedKey.point)
        aCoder.encode(self.scoreAverage, forKey: SerializedKey.scoreAverage)
        aCoder.encode(self.isNotificationOptedIn, forKey: SerializedKey.isNotificationOptedIn)
    }
}
