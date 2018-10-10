//
//  RegisterTokenRequest.swift
//  pochi
//
//  Created by akiho on 2017/09/13.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RegisterTokenRequest: RequestJsonParsable {
    let registrationToken: String
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["registrationToken"] = self.registrationToken
        return dictionary
    }
}
