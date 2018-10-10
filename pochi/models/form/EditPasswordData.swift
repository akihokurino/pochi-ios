//
//  EditPasswordData.swift
//  pochi
//
//  Created by akiho on 2017/06/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

struct EditPasswordData: FormData {
    
    let password = InputCellData(
        label: "現在のパスワード",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil,
        isMask: true)

    
    let newPassword = InputCellData(
        label: "新しいパスワード",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil,
        isMask: true)
    
    func getProperties() -> [InputCellData] {
        return [password, newPassword]
    }
    
    func observeInput() -> Observable<SendData> {
        return Observable.combineLatest(
            password.value.asObservable(),
            newPassword.value.asObservable(),
            resultSelector: { password, newPassword -> SendData in
                return SendData(password: password, newPassword: newPassword)
            })
    }
    
    struct SendData {
        let password: String
        let newPassword: String
        
        func isAllInputFilled() -> Bool {
            return !password.isEmpty && !newPassword.isEmpty
        }
    }
}

