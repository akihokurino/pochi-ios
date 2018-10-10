//
//  SignUpRequest.swift
//  pochi
//
//  Created by akiho on 2017/03/31.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CreateUserRequest: RequestJsonParsable {
    let firstName: String
    let lastName: String
    let nickName: String
   
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["firstName"] = self.firstName
        dictionary["lastName"] = self.lastName
        dictionary["nickname"] = self.nickName
        return dictionary
    }
}
