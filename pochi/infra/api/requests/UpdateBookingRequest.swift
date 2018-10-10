//
//  UpdateBookingRequest.swift
//  pochi
//
//  Created by akiho on 2017/07/03.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UpdateBookingRequest: RequestJsonParsable {
    let cardToken: String
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["cardToken"] = self.cardToken
        return dictionary
    }
}
