//
//  UserRepository.swift
//  pochi
//
//  Created by akiho on 2017/07/12.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

class UserRepository: ProvideTokenProtocol {
    static let shared = UserRepository()
    
    private var provider: RxMoyaProvider<UserApi> {
        return RxMoyaProvider<UserApi>(plugins: [authPlugin])
    }
    
    private init() {
        
    }
    
    func fetch(id: String) -> Observable<User> {
        return self.provider.request(.fetch(id: id))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> User in
                return UserResponse.from(json: json).to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
}

