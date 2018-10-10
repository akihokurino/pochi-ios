//
//  CreateMessageRequest.swift
//  pochi
//
//  Created by akiho on 2017/07/03.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CreateMessageRequest: RequestJsonParsable {
    let from: String
    let content: String?
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["from"] = self.from
        dictionary["content"] = self.content
        return dictionary
    }
}
