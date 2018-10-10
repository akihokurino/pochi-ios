//
//  UpdateUserRequest.swift
//  pochi
//
//  Created by akiho on 2017/07/03.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UpdateUserRequest: RequestJsonParsable {
    let nickName: String
    let introductionMessage: String
    let imageData: String?
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["nickname"] = self.nickName
        dictionary["introductionMessage"] = self.introductionMessage
        dictionary["imageData"] = self.imageData
        return dictionary
    }
}
