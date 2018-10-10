//
//  EditEmailData.swift
//  pochi
//
//  Created by akiho on 2017/06/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

struct EditEmailData: FormData {
    
    let email = InputCellData(
        label: "メールアドレス",
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
