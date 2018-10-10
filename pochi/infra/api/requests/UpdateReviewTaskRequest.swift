//
//  UpdateReviewTaskRequest.swift
//  pochi
//
//  Created by akiho on 2017/08/27.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UpdateReviewTaskRequest: RequestJsonParsable {
    let score: Int
    let content: String
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["score"] = self.score
        dictionary["content"] = self.content
        return dictionary
    }
}
