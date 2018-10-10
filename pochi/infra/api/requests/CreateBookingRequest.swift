//
//  CreateBookingRequest.swift
//  pochi
//
//  Created by akiho on 2017/07/01.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CreateBookingRequest: RequestJsonParsable {
    let sitterId: String
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["hostId"] = self.sitterId
        return dictionary
    }
}
