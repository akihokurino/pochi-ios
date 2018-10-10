//
//  MessageResponse.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MessageResponse: ResponseJsonParsable {
    let bookingId: Int64
    let id: Int64
    let from: UserOverviewResponse
    let type: String
    let imageUri: String?
    let content: String?
    let createdAt: Int64?
    
    static func from(json: JSON!) -> MessageResponse {
        return MessageResponse(bookingId: json["bookingId"].int64Value,
                               id: json["id"].int64Value,
                               from: UserOverviewResponse.from(json: json["from"]),
                               type: json["type"].stringValue,
                               imageUri: json["imageUri"].string,
                               content: json["content"].string,
                               createdAt: json["createdAt"].int64)
    }
    
    func to() -> Message {
        return Message(bookingId: self.bookingId,
                       id: self.id,
                       from: self.from.to(),
                       rawType: self.type,
                       imageUri: self.imageUri,
                       content: self.content,
                       createdAt: self.createdAt)
    }
}
