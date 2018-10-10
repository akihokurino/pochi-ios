//
//  ResetPasswordViewModel.swift
//  pochi
//
//  Created by akiho on 2017/04/30.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class ResetPasswordViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    private var sendFormData: ResetPasswordData.SendData? = nil
    
    private(set) var isSending: Bool = false
    
    func bind(data: ResetPasswordData.SendData) {
        self.sendFormData = data
    }
    
    func resetPassword() -> Observable<Void> {
        isSending = true
        return AppUserRepository.shared.sendPasswordForReset(data: self.sendFormData!)
            .do(onNext: { _ in
                self.isSending = false
            }, onError: { e in
                self.isSending = false
            })
    }
}
