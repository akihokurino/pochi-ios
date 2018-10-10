//
//  SignInViewModel.swift
//  pochi
//
//  Created by akiho on 2017/04/30.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class SignInViewModel {
    private var sendFormData: SignInFormData.SendData? = nil
    
    private(set) var isLoading: Bool = false
    
    func bind(data: SignInFormData.SendData) {
        self.sendFormData = data
    }
    
    func signIn() -> Observable<AppUser> {
        isLoading = true
        return AppUserRepository.shared.authenticate(data: self.sendFormData!)
            .do(onNext: { _ in
                self.isLoading = false
            }, onError: { e in
                self.isLoading = false
            })
    }
}
