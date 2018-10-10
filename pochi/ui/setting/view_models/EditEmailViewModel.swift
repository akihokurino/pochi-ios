//
//  EditEmailViewModel.swift
//  pochi
//
//  Created by akiho on 2017/08/09.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class EditEmailViewModel {
    private var sendFormData: EditEmailData.SendData!
    
    private(set) var isLoading: Bool = false
    
    func bind(data: EditEmailData.SendData) {
        self.sendFormData = data
    }
    
    func update() -> Observable<AppUser> {
        self.isLoading = true
        
        return AppUserRepository.shared
            .updateEmail(appUser: AppUserStore.shared.restore()!, data: sendFormData)
            .do(onNext: { _ in
                self.isLoading = false
            }, onError: { e in
                self.isLoading = false
            })
    }
}
