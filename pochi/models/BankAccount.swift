//
//  BankAccount.swift
//  pochi
//
//  Created by akiho on 2017/06/06.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class BankAccount {
    
    enum RecipientType: String {
        case individual = "individual"
        case corporation = "corporation"
    }
    
    enum AccountType: String {
        case normal = "NORMAL"
        case current = "CURRENT"
    }
    
    let id: String
    let isActive: Bool
    let recipientType: RecipientType
    let accountType: AccountType
    let bankCode: String
    let branchCode: String
    let lastDigits: String
    let name: String
    
    var bank: Bank?
    var branch: Bank.Branch?
    
    init(id: String, isActive: Bool, rawRecipientType: String, rawAccountType: String, bankCode: String, branchCode: String, lastDigits: String, name: String) {
        self.id = id
        self.isActive = isActive
        self.recipientType = RecipientType(rawValue: rawRecipientType)!
        self.accountType = AccountType(rawValue: rawAccountType)!
        self.bankCode = bankCode
        self.branchCode = branchCode
        self.lastDigits = lastDigits
        self.name = name
        
        self.bank = nil
        self.branch = nil
    }
}
