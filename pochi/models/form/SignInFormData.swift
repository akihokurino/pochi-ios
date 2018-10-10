//
//  LoginData.swift
//  pochi
//
//  Created by akiho on 2016/12/19.
//  Copyright © 2016年 akiho. All rights reserved.
//

import Foundation
import RxSwift

struct SignInFormData: FormData {
    
    typealias T = SendData
    
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
        return [email, password]
    }
    
    func observeInput() -> Observable<T> {
        return Observable.combineLatest(
            email.value.asObservable(),
            password.value.asObservable(),
            resultSelector: { email, password -> SendData in
                return SendData(email: email, password: password)
            })
    }
    
    struct SendData {
        let email: String
        let password: String
    
        func isAllInputFilled() -> Bool {
            return !email.isEmpty && !password.isEmpty
        }
    }
}
