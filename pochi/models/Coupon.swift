//
//  Coupon.swift
//  pochi
//
//  Created by akiho on 2017/10/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation

class Coupon {
    let code: Int64
    let discountPrice: Int64
    let available: Bool?
    let limitDate: String?
    
    init(code: Int64, discountPrice: Int64, available: Bool?, limitDate: String?) {
        self.code = code
        self.discountPrice = discountPrice
        self.available = available
        self.limitDate = limitDate
    }
}
