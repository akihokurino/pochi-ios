//
//  SignUpViewModel.swift
//  pochi
//
//  Created by akiho on 2017/04/30.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class SignUpViewModel {
    private var sendFormData: SignUpFormData.SendData!
    
    private(set) var isLoading: Bool = false
    
    func bind(data: SignUpFormData.SendData) {
        self.sendFormData = data
    }
    
    func signUp() -> Observable<AppUser> {
        isLoading = true
        return AppUserRepository.shared.create(data: sendFormData)
            .do(onNext: { _ in
                self.isLoading = false
            }, onError: { e in
                self.isLoading = false
            })
    }
    
    func deleteFBUser() {
        AppUserRepository.shared.deleteFBUser()
    }
}
