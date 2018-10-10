//
//  CreateReviewRequest.swift
//  pochi
//
//  Created by akiho on 2017/07/03.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CreateReviewRequest: RequestJsonParsable {
    let from: String
    let target: String
    let type: String
    let score: Int
    let content: String
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["from"] = self.from
        dictionary["target"] = self.target
        dictionary["type"] = self.type
        dictionary["score"] = self.score
        dictionary["content"] = self.content
        return dictionary
    }
}
