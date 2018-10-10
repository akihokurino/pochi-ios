//
//  UpdateBookingStatusRequest.swift
//  pochi
//
//  Created by akiho on 2017/09/09.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UpdateBookingStatusRequest: RequestJsonParsable {
    let status: String
   
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["status"] = self.status
        return dictionary
    }
}
