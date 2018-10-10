//
//  SignUpData.swift
//  pochi
//
//  Created by akiho on 2016/12/20.
//  Copyright © 2016年 akiho. All rights reserved.
//

import Foundation
import RxSwift

struct SignUpFormData: FormData {
    
    enum FireAuthType {
        case email_pass
        case facebook
    }
    
    var fireAuthType: FireAuthType = .email_pass
    
    let lastName = InputCellData(
        label: "姓",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil)
    
    let firstName = InputCellData(
        label: "名",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil)
    
    let nickName = InputCellData(
        label: "ニックネーム",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil)
    
    let email = InputCellData(
        label: "メールアドレス",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil)
    
    let password = InputCellData(
        label: "パスワード",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil,
        isMask: true)
    
    func getProperties() -> [InputCellData] {
        switch fireAuthType {
        case .email_pass:
            return [lastName, firstName, nickName, email, password]
        case .facebook:
            return [lastName, firstName, nickName]
        }
    }
    
    func observeInput() -> Observable<SendData> {
        return Observable.combineLatest(
            lastName.value.asObservable(),
            firstName.value.asObservable(),
            nickName.value.asObservable(),
            email.value.asObservable(),
            password.value.asObservable(),
            resultSelector: { lastName, firstName, nickName, email, password -> SendData in
                return SendData(
                    lastName: lastName,
                    firstName: firstName,
                    nickName: nickName,
                    email: email,
                    password: password)
            })
    }
    
    struct SendData {
        let lastName: String
        let firstName: String
        let nickName: String
        let email: String
        let password: String
        
        func isAllInputFilled() -> Bool {
            return !lastName.isEmpty && !firstName.isEmpty && !nickName.isEmpty && !email.isEmpty && !password.isEmpty
        }
    }
}
