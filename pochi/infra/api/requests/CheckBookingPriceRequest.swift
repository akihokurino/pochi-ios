//
//  CheckBookingPriceRequest.swift
//  pochi
//
//  Created by akiho on 2017/10/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CheckBookingPriceRequest: RequestJsonParsable {
    let dogIds: [Int64]
    let startDate: String
    let endDate: String
    let usePoint: Int64?
    let couponCode: Int64?
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["dogIds"] = self.dogIds
        dictionary["startDate"] = self.startDate
        dictionary["endDate"] = self.endDate
        dictionary["usePoint"] = self.usePoint
        dictionary["couponCode"] = self.couponCode
        return dictionary
    }
}
