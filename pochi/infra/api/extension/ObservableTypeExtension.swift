//
//  ObservableTypeExtension.swift
//  pochi
//
//  Created by akiho on 2017/03/25.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import Moya

struct RetryConfig {
    var currentEntryCount = 0
    static let MAX_RETRY_COUNT = 5
    static let DEFAULT_RETRY_TIME: Double = 1.5
    static let MULTIPLIED: Double = 1.5
}

extension ObservableType where E == Response {
    func convertToJsonObservable() -> Observable<JSON> {
        return flatMap({ response -> Observable<JSON> in
            let json = JSON(data: response.data)
            return Observable.just(json)
        })
    }
    
    func filterError() -> Observable<E> {
        return flatMap({ response -> Observable<Response> in
            if 400 <= response.statusCode {
                throw NSError(domain: "", code: response.statusCode, userInfo: nil)
            }
            return Observable.just(response)
        })
    }
    
    func retryIfError() -> Observable<E> {
        return retryWhen { errors -> Observable<Int64> in
            var config = RetryConfig()
            
            return errors.flatMap { err -> Observable<Int64> in
                let e = err as NSError
                config.currentEntryCount += 1
                
                if 500..<600 ~= e.code && config.currentEntryCount <= RetryConfig.MAX_RETRY_COUNT {
                    return Observable.timer(
                        self.retryTiming(retryCount: config.currentEntryCount),
                        scheduler: SerialDispatchQueueScheduler(qos: .background))
                }
                return Observable.error(err)
            }
        }
    }
    
    private func retryTiming(retryCount: Int, retryTime: Double = RetryConfig.DEFAULT_RETRY_TIME) -> RxTimeInterval {
        if (retryCount <= 1) {
            return RxTimeInterval(retryTime)
        } else {
            return retryTiming(retryCount: retryCount - 1, retryTime: retryTime * RetryConfig.MULTIPLIED)
        }
    }
}
