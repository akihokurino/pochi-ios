//
//  CouponRepository.swift
//  pochi
//
//  Created by akiho on 2017/10/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

class CouponRepository: ProvideTokenProtocol {
    static let shared = CouponRepository()
    
    private var provider: RxMoyaProvider<CouponApi> {
        return RxMoyaProvider<CouponApi>(plugins: [authPlugin])
    }
    
    private init() {
        
    }
    
    func fetch(code: Int64) -> Observable<Coupon> {
        return provider.request(.fetch(code: code))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> Coupon in
                return CouponResponse.from(json: json).to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
}
