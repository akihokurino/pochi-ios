//
//  EditPaymentInfoFormData.swift
//  pochi
//
//  Created by akiho on 2017/06/05.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

struct EditPaymentInfoFormData: FormData {
    
    let cardNumber = InputCellData(
        label: "カード番号",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil)
    
    let name = InputCellData(
        label: "名義",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil)
    
    let expirationDate = InputCellData(
        label: "有効期限",
        value: "",
        type: InputCellData.InputType.PickerTextField,
        selectItems: [])
    
    let securityCode = InputCellData(
        label: "セキュリティコード",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil)

    func getProperties() -> [InputCellData] {
        return [cardNumber, name, expirationDate, securityCode]
    }
    
    func observeInput() -> Observable<SendData> {
        return Observable.combineLatest(
            cardNumber.value.asObservable(),
            name.value.asObservable(),
            expirationDate.value.asObservable(),
            securityCode.value.asObservable(),
            resultSelector: { cardNumber, name, expirationDate, securityCode -> SendData in
                return SendData(cardNumber: cardNumber,
                                name: name,
                                expirationDate: expirationDate,
                                securityCode: securityCode)
            })
    }
    
    struct SendData {
        let cardNumber: String
        let name: String
        let expirationDate: String
        let securityCode: String
        
        func isAllInputFilled() -> Bool {
            return !cardNumber.isEmpty && !name.isEmpty && !expirationDate.isEmpty && !securityCode.isEmpty
        }
    }
}


