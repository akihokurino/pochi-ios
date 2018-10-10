//
//  EditUserProfileViewModel.swift
//  pochi
//
//  Created by akiho on 2017/07/03.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class EditUserProfileViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    private var sendFormData: EditProfileData.SendData!
    private var sendImageData: UIImage?
    
    private(set) var isLoading: Bool = false
    let appUser: AppUser = AppUserStore.shared.restore()!
    
    func bind(data: EditProfileData.SendData) {
        self.sendFormData = data
    }
    
    func bind(image: UIImage) {
        self.sendImageData = image
    }
    
    func update() -> Observable<AppUser> {
        isLoading = true
        
        return AppUserRepository.shared.update(data: sendFormData!)
            .flatMap({ appUser -> Observable<AppUser> in
                if let imageData = self.sendImageData {
                    return AppUserRepository.shared.updateIcon(image: imageData)
                } else {
                    return Observable.just(appUser)
                }
            })
            .do(onNext: { _ in
                self.isLoading = false
            }, onError: { e in
                self.isLoading = false
            })
    }
}
