//
//  SitterRepository.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

class SitterRepository: ProvideTokenProtocol {
    static let shared = SitterRepository()
    
    private var provider: RxMoyaProvider<SitterApi> {
        return RxMoyaProvider<SitterApi>(plugins: [authPlugin])
    }
    
    private init() {
        
    }
    
    func fetchAll() -> Pagination<ItemsResponse<SitterResponse>, [Sitter]> {
        return Pagination<ItemsResponse<SitterResponse>, [Sitter]>(
            load: { cursor in
                return self.provider.request(.fetchAll(cursor: cursor))
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> ItemsResponse<SitterResponse> in
                        return ItemsResponse<SitterResponse>.from(json: json)
                    })
            },
            convert: { response -> [Sitter] in
                return response.items.map({ $0.to() })
            }
        )
    }
    
    func fetchHistory() -> Observable<[Sitter]> {
        return self.provider.request(.fetchAll(cursor: ""))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> [Sitter] in
                return ItemsResponse<SitterResponse>.from(json: json).items.map({ $0.to() })
            })
    }
    
    func fetchSearchResult(zipCode: String) -> Pagination<ItemsResponse<SitterResponse>, [Sitter]> {
        return Pagination<ItemsResponse<SitterResponse>, [Sitter]>(
            load: { cursor in
                return self.provider.request(.search(zipCode: zipCode, cursor: cursor))
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> ItemsResponse<SitterResponse> in
                        return ItemsResponse<SitterResponse>.from(json: json)
                    })
            },
            convert: { response -> [Sitter] in
                return response.items.map({ $0.to() })
            }
        )
    }
    
    func fetch(id: String) -> Observable<Sitter> {
        return self.provider.request(.fetch(id: id))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> Sitter in
                return SitterResponse.from(json: json).to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
}
