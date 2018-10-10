//
//  CreateBankAccountData.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

struct CreateBankAccountData: FormData {
    
    typealias T = SendData
    
//    let recipientType = InputCellData(
//        label: "個人 or 法人",
//        value: "",
//        type: InputCellData.InputType.PickerTextFieldWithSection,
//        selectItems: ["個人", "法人"])
    
    let accountType = InputCellData(
        label: "口座種別",
        value: "",
        type: InputCellData.InputType.PickerTextFieldWithSection,
        selectItems: ["普通", "当座"])

    let branchCode = InputCellData(
        label: "支店コード",
        value: "",
        type: InputCellData.InputType.TextFieldWithSection,
        selectItems: nil)

    let number = InputCellData(
        label: "口座番号",
        value: "",
        type: InputCellData.InputType.TextFieldWithSection,
        selectItems: nil)

    let name = InputCellData(
        label: "名義（カタカナ）",
        value: "",
        type: InputCellData.InputType.TextFieldWithSection,
        selectItems: nil)

    func getProperties() -> [InputCellData] {
        return [accountType, branchCode, number, name]
    }
    
    func observeInput() -> Observable<T> {
        return Observable.combineLatest(
//            recipientType.value.asObservable(),
            accountType.value.asObservable(),
            branchCode.value.asObservable(),
            number.value.asObservable(),
            name.value.asObservable(),
            resultSelector: { accountType, branchCode, number, name -> SendData in
                let recipientTypeValue: String = BankAccount.RecipientType.individual.rawValue
//                if recipientType == "個人" {
//                    recipientTypeValue = BankAccount.RecipientType.individual.rawValue
//                } else if recipientType == "法人" {
//                    recipientTypeValue = BankAccount.RecipientType.corporation.rawValue
//                }
                
                var accountTypeValue: String = ""
                if accountType == "普通" {
                    accountTypeValue = BankAccount.AccountType.normal.rawValue
                } else if accountType == "当座" {
                    accountTypeValue = BankAccount.AccountType.current.rawValue
                }
                
                return SendData(recipientType: recipientTypeValue,
                                accountType: accountTypeValue,
                                branchCode: branchCode,
                                number: number,
                                name: name)
        })
    }
    
    struct SendData {
        let recipientType: String
        let accountType: String
        let branchCode: String
        let number: String
        let name: String
        
        func isAllInputFilled() -> Bool {
            return !recipientType.isEmpty && !accountType.isEmpty && !branchCode.isEmpty && !number.isEmpty && !name.isEmpty
        }
    }
}
