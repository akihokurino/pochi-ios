//
//  InputPostalCodeData.swift
//  pochi
//
//  Created by akiho on 2017/05/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

struct InputPostalCodeData: FormData {
    
    let postalCode = InputCellData(
        label: "郵便番号",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil)
    
    func getProperties() -> [InputCellData] {
        return [postalCode]
    }
    
    func observeInput() -> Observable<SendData> {
        return postalCode.value.asObservable().map({ postalCode -> SendData in
            return SendData(postalCode: postalCode)
        })
    }
    
    struct SendData {
        let postalCode: String
        
        func isAllInputFilled() -> Bool {
            return !postalCode.isEmpty
        }
    }
}

