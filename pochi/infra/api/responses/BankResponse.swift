//
//  BankResponse.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BankResponse: ResponseJsonParsable {
    let code: String
    let kana: String
    let name: String
    
    static func from(json: JSON!) -> BankResponse {
        return BankResponse(code: json["code"].stringValue,
                            kana: json["kana"].stringValue,
                            name: json["name"].stringValue)
    }
    
    func to() -> Bank {
        return Bank(code: self.code, kana: self.kana, name: self.name)
    }
}
