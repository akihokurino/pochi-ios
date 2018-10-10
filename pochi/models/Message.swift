//
//  Message.swift
//  pochi
//
//  Created by akiho on 2017/04/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class Message {
    enum ContentType: String {
        case user = "USER"
        case system = "SYSTEM"
    }
    
    let bookingId: Int64
    let id: Int64
    let from: UserOverview
    let type: ContentType
    let imageUri: String?
    let content: String?
    let createdAt: Int64?
    
    init(bookingId: Int64, id: Int64, from: UserOverview, rawType: String, imageUri: String?, content: String?, createdAt: Int64?) {
        self.bookingId = bookingId
        self.id = id
        self.from = from
        self.type = ContentType(rawValue: rawType)!
        self.imageUri = imageUri
        self.content = content
        self.createdAt = createdAt
    }
}
