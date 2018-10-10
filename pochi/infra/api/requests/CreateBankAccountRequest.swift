//
//  CreateBankAccountRequest.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CreateBankAccountRequest: RequestJsonParsable {
    let recipientType: String
    let accountType: String
    let bankCode: String
    let branchCode: String
    let number: String
    let name: String
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["recipientType"] = self.recipientType
        dictionary["accountType"] = self.accountType
        dictionary["bankCode"] = self.bankCode
        dictionary["branchCode"] = self.branchCode
        dictionary["number"] = self.number
        dictionary["name"] = self.name.applyingTransform(.fullwidthToHalfwidth, reverse: false)
        return dictionary
    }
}
