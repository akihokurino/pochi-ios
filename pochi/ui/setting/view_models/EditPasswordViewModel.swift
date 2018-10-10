//
//  EditPasswordViewModel.swift
//  pochi
//
//  Created by akiho on 2017/08/09.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class EditPasswordViewModel {
    private var sendFormData: EditPasswordData.SendData!
    
    private(set) var isLoading: Bool = false
    
    func bind(data: EditPasswordData.SendData) {
        self.sendFormData = data
    }
    
    func update() -> Observable<Void> {
        self.isLoading = true
        
        return AppUserRepository.shared.updatePassword(
            appUser: AppUserStore.shared.restore()!,
            data: self.sendFormData)
            .do(onNext: { _ in
                self.isLoading = false
            }, onError: { e in
                self.isLoading = false
            })
    }
}
