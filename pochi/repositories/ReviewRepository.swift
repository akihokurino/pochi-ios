//
//  ReviewRepository.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

class ReviewRepository: ProvideTokenProtocol {
    static let shared = ReviewRepository()
    
    private var provider: RxMoyaProvider<ReviewApi> {
        return RxMoyaProvider<ReviewApi>(plugins: [authPlugin])
    }
    
    private init() {
        
    }
        
    func fetchAll(user: User) -> Pagination<ItemsResponse<ReviewResponse>, ([Review], Int)> {
        return Pagination<ItemsResponse<ReviewResponse>, ([Review], Int)>(
            load: { cursor in
                return self.provider.request(.fetchAllOfUser(userId: user.overview.id, cursor: cursor))
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> ItemsResponse<ReviewResponse> in
                        return ItemsResponse<ReviewResponse>.from(json: json)
                    })
            },
            convert: { response -> ([Review], Int) in
                return (response.items.map({ $0.to() }), response.totalCount ?? 0)
            })
    }
    
    func fetchAll(sitter: Sitter) -> Pagination<ItemsResponse<ReviewResponse>, ([Review], Int)> {
        return Pagination<ItemsResponse<ReviewResponse>, ([Review], Int)>(
            load: { cursor in
                return self.provider.request(.fetchAllOfSitter(sitterId: sitter.overview.id, cursor: cursor))
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> ItemsResponse<ReviewResponse> in
                        return ItemsResponse<ReviewResponse>.from(json: json)
                    })
            },
            convert: { response -> ([Review], Int) in
                return (response.items.map({ $0.to() }), response.totalCount ?? 0)
            })
    }
    
    func create(booking: Booking) -> Observable<Review> {
        let requestData = CreateReviewRequest(from: "",
                                              target: "",
                                              type: "",
                                              score: 0,
                                              content: "")
        return provider.request(.create(bookingId: booking.id, data: requestData))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> Review in
                return ReviewResponse.from(json: json).to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
}
