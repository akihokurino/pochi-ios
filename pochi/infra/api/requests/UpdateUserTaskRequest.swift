//
//  CreateUserTaskRequest.swift
//  pochi
//
//  Created by akiho on 2017/07/03.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UpdateUserTaskRequest: RequestJsonParsable {
    let status: String
    let message: CreateMessageRequest?
    let review: CreateReviewRequest?
    
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["status"] = self.status
        dictionary["message"] = self.message?.toDictionary()
        dictionary["review"] = self.review?.toDictionary()
        return dictionary
    }
}
