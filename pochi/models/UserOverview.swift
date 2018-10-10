//
//  UserOverview.swift
//  pochi
//
//  Created by Akiho Kurino on 2017/07/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation

class UserOverview {
    let id: String
    let firstName: String
    let lastName: String
    let nickname: String
    let iconUri: String
    
    init(id: String,
         firstName: String,
         lastName: String,
         nickname: String,
         iconUri: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.nickname = nickname
        self.iconUri = iconUri
    }
}
