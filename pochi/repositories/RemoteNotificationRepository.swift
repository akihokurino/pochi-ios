//
//  RemoteNotificationRepository.swift
//  pochi
//
//  Created by akiho on 2017/09/13.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

class RemoteNotificationRepository: ProvideTokenProtocol {
    static let shared = RemoteNotificationRepository()
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    private var provider: RxMoyaProvider<UserApi> {
        return RxMoyaProvider<UserApi>(plugins: [authPlugin])
    }
    
    private init() {
        
    }
    
    func registerToken(token: String) {
        guard let user = AppUserStore.shared.restore() else {
            return
        }
        
        let requestData = RegisterTokenRequest(registrationToken: token)
        
        self.provider.request(.registerFcmToken(id: user.overview.id, data: requestData))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> Void in
                
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {}, onError: { e in })
            .addDisposableTo(disposeBag)
    }
}

