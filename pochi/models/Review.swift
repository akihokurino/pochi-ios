//
//  Review.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class Review {
    
    let bookingId: Int64
    let reviewer: UserOverview
    let target: String
    let score: Int
    let content: String
    let createdAt: Int64
    
    init(bookingId: Int64, reviewer: UserOverview, target: String, score: Int, content: String, createdAt: Int64) {
        self.bookingId = bookingId
        self.reviewer = reviewer
        self.target = target
        self.score = score
        self.content = content
        self.createdAt = createdAt
    }
}
