//
//  BankBranchResponse.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BankBranchResponse: ResponseJsonParsable {
    let code: String
    let kana: String
    let name: String
    
    static func from(json: JSON!) -> BankBranchResponse {
        return BankBranchResponse(code: json["code"].stringValue,
                                  kana: json["kana"].stringValue,
                                  name: json["name"].stringValue)
    }
    
    func to() -> Bank.Branch {
        return Bank.Branch(code: self.code, kana: self.kana, name: self.name)
    }
}
