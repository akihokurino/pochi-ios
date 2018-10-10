//
//  ReviewResponse.swift
//  pochi
//
//  Created by akiho on 2017/07/01.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ReviewResponse: ResponseJsonParsable {
    let bookingId: Int64
    let reviewer: UserOverviewResponse
    let target: String
    let score: Int
    let content: String
    let createdAt: Int64
    
    static func from(json: JSON!) -> ReviewResponse {
        return ReviewResponse(bookingId: json["bookingId"].int64Value,
                              reviewer: UserOverviewResponse.from(json: json["reviewer"]),
                              target: json["target"].stringValue,
                              score: json["score"].intValue,
                              content: json["comment"].stringValue,
                              createdAt: json["createdAt"].int64Value)
    }
    
    func to() -> Review {
        return Review(bookingId: bookingId,
                      reviewer: reviewer.to(),
                      target: target,
                      score: score,
                      content: content,
                      createdAt: createdAt)
    }
}
