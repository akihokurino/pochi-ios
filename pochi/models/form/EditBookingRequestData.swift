//
//  EditBookingRequestData.swift
//  pochi
//
//  Created by akiho on 2017/10/22.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

struct EditBookingRequestData: FormData {
    
    let dogNames = InputCellData(
        label: "犬の名前",
        value: "",
        type: InputCellData.InputType.PickerTextField,
        selectItems: [],
        isWriteOnce: true)
    
    let startDate = InputCellData(
        label: "開始日",
        value: "",
        type: InputCellData.InputType.CalendarTextField,
        selectItems: nil)
    
    var endDate = InputCellData(
        label: "終了日",
        value: "",
        type: InputCellData.InputType.CalendarTextField,
        selectItems: nil)
    
    let point = InputCellData(
        label: "ポイントの利用[任意]",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil,
        isNumberInput: true)
    
    let coupon = InputCellData(
        label: "クーポンコード[任意]",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil)
    
    func getProperties() -> [InputCellData] {
        return [dogNames, startDate, endDate, point, coupon]
    }
    
    func observeInput() -> Observable<SendData> {
        return Observable.combineLatest(
            dogNames.value.asObservable(),
            startDate.value.asObservable(),
            endDate.value.asObservable(),
            point.value.asObservable(),
            coupon.value.asObservable(),
            resultSelector: { dogNames, startDate, endDate, point, coupon -> SendData in
                return SendData(dogNames: dogNames,
                                startDate: startDate,
                                endDate: endDate,
                                point: Int64(point),
                                coupon: Int64(coupon))
            })
    }
    
    struct SendData {
        let dogNames: String
        let startDate: String
        let endDate: String
        let point: Int64?
        let coupon: Int64?
        
        func isAllInputFilled(availablePoint: Int64?) -> Bool {
            guard let _availablePoint = availablePoint else {
                return false
            }
            
            let isValidPoint: Bool = !(point != nil && point! > 0 && point! > _availablePoint)
            return !dogNames.isEmpty && !startDate.isEmpty && !endDate.isEmpty && isValidPoint
        }
    }
}
