//
//  CouponResponse.swift
//  pochi
//
//  Created by akiho on 2017/10/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CouponResponse: ResponseJsonParsable {
    let code: Int64
    let discountPrice: Int64
    let available: Bool?
    let limitDate: String?
    
    static func from(json: JSON!) -> CouponResponse {
        return CouponResponse(code: json["couponCode"].int64Value,
                              discountPrice: json["discountPrice"].int64Value,
                              available: json["available"].bool,
                              limitDate: json["limitDate"].string)
    }
    
    func to() -> Coupon {
        return Coupon(code: code, discountPrice: discountPrice, available: available, limitDate: limitDate)
    }
}
