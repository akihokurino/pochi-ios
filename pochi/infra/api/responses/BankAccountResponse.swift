//
//  BankAccountResponse.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BankAccountResponse: ResponseJsonParsable {
    let id: String
    let active: Bool
    let recipientType: String
    let accountType: String
    let bankCode: String
    let branchCode: String
    let lastDigits: String
    let name: String

    static func from(json: JSON!) -> BankAccountResponse {
        return BankAccountResponse(id: json["id"].stringValue,
                                   active: json["active"].boolValue,
                                   recipientType: json["recipientType"].stringValue,
                                   accountType: json["accountType"].stringValue,
                                   bankCode: json["bankCode"].stringValue,
                                   branchCode: json["branchCode"].stringValue,
                                   lastDigits: json["lastDigits"].stringValue,
                                   name: json["name"].stringValue)
    }
    
    func to() -> BankAccount {
        return BankAccount(id: id,
                           isActive: active,
                           rawRecipientType: recipientType,
                           rawAccountType: accountType,
                           bankCode: bankCode,
                           branchCode: branchCode,
                           lastDigits: lastDigits,
                           name: name)
    }
}
