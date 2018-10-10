//
//  EditProfileData.swift
//  pochi
//
//  Created by akiho on 2017/02/05.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

struct EditProfileData {
    let nickName = InputCellData(
        label: "ニックネーム",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil)
    let profile = InputCellData(
        label: "プロフィール",
        value: "",
        type: InputCellData.InputType.TextView,
        selectItems: nil)
    
    func getProperties() -> [InputCellData] {
        return [nickName, profile]
    }
    
    func observeInput() -> Observable<SendData> {
        return Observable.combineLatest(
            nickName.value.asObservable(),
            profile.value.asObservable(),
            resultSelector: { nickName, profile -> SendData in
                return SendData(
                    nickName: nickName,
                    introductionMessage: profile,
                    imageData: "")
        })
    }
    
    struct SendData {
        let nickName: String
        let introductionMessage: String
        let imageData: String
        
        func isAllInputFilled() -> Bool {
            return !nickName.isEmpty
        }
    }
}
