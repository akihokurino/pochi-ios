//
//  CreateDogViewModel.swift
//  pochi
//
//  Created by akiho on 2017/04/30.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class CreateDogViewModel {
    private var sendFormData: [CreateDogData.SendData] = []
    
    private(set) var isLoading: Bool = false
    
    func bind(data: CreateDogData.SendData) {
        self.sendFormData = [data]
    }
    
    func create(user: AppUser, more: [CreateDogData.SendData]) -> Observable<[Dog]> {
        isLoading = true
        sendFormData.append(contentsOf: more)
    
        var requests: [Observable<Dog>] = []
        
        sendFormData.forEach {
            requests.append(DogRepository.shared.create(user: user, data: $0))
        }
        
        return Observable.combineLatest(requests, { results in
            return results
        }).do(onNext: { _ in
            self.isLoading = false
        }, onError: { e in
            self.isLoading = false
        })
    }
}
