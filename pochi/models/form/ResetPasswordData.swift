//
//  ResetPasswordData.swift
//  pochi
//
//  Created by akiho on 2016/12/19.
//  Copyright © 2016年 akiho. All rights reserved.
//

import Foundation
import RxSwift

struct ResetPasswordData: FormData {
    
    let email = InputCellData(
        label: "登録したメールアドレス",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil)
    
    func getProperties() -> [InputCellData] {
        return [email]
    }
    
    func observeInput() -> Observable<SendData> {
        return email.value.asObservable().map({ email -> SendData in
            return SendData(email: email)
        })
    }
    
    struct SendData {
        let email: String
        
        func isAllInputFilled() -> Bool {
            return !email.isEmpty
        }
    }
}
