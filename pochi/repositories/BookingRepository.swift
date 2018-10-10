//
//  BookingRepository.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

class BookingRepository: ProvideTokenProtocol {
    static let shared = BookingRepository()
    
    private var provider: RxMoyaProvider<BookingApi> {
        return RxMoyaProvider<BookingApi>(plugins: [authPlugin])
    }
    
    private init() {
        
    }
    
    func fetchAll(user: AppUser) -> Pagination<ItemsResponse<BookingResponse>, [Booking]> {
        return Pagination<ItemsResponse<BookingResponse>, [Booking]>(
            load: { cursor in
                return self.provider.request(.fetchAllOfUser(userId: user.overview.id, cursor: cursor))
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> ItemsResponse<BookingResponse> in
                        return ItemsResponse<BookingResponse>.from(json: json)
                    })
                    .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            },
            convert: { response -> [Booking] in
                return response.items.map({ $0.to() })
            }
        )
    }
    
    func fetchAll(sitter: AppUser) -> Pagination<ItemsResponse<BookingResponse>, [Booking]> {
        return Pagination<ItemsResponse<BookingResponse>, [Booking]>(
            load: { cursor in
                return self.provider.request(.fetchAllOfSitter(sitterId: sitter.overview.id, cursor: cursor))
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> ItemsResponse<BookingResponse> in
                        return ItemsResponse<BookingResponse>.from(json: json)
                    })
                    .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            },
            convert: { response -> [Booking] in
                return response.items.map({ $0.to() })
            }
        )
    }
    
    func fetchAllClosed(user: AppUser) -> Pagination<ItemsResponse<BookingResponse>, [Booking]> {
        return Pagination<ItemsResponse<BookingResponse>, [Booking]>(
            load: { cursor in
                return self.provider.request(.fetchAllClosedOfUser(userId: user.overview.id, cursor: cursor))
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> ItemsResponse<BookingResponse> in
                        return ItemsResponse<BookingResponse>.from(json: json)
                    })
                    .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            },
            convert: { response -> [Booking] in
                return response.items.map({ $0.to() })
            }
        )
    }
    
    func fetchAllClosed(sitter: AppUser) -> Pagination<ItemsResponse<BookingResponse>, [Booking]> {
        return Pagination<ItemsResponse<BookingResponse>, [Booking]>(
            load: { cursor in
                return self.provider.request(.fetchAllClosedOfSitter(sitterId: sitter.overview.id, cursor: cursor))
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> ItemsResponse<BookingResponse> in
                        return ItemsResponse<BookingResponse>.from(json: json)
                    })
                    .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            },
            convert: { response -> [Booking] in
                return response.items.map({ $0.to() })
            }
        )
    }
    
    func create(sitter: Sitter) -> Observable<Booking> {
        let requestData = CreateBookingRequest(sitterId: sitter.overview.id)
        return provider.request(.create(data: requestData))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> Booking in
                return BookingResponse.from(json: json).to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func request(booking: Booking, cardToken: String) -> Observable<Booking> {
        let requestData = UpdateBookingRequest(cardToken: cardToken)
        return provider.request(.request(id: booking.id, data: requestData))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> Booking in
                return BookingResponse.from(json: json).to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func check(booking: Booking, data: EditBookingRequestData.SendData) -> Observable<Booking> {
        let dogIds = data.dogNames.components(separatedBy: ",").map({ name -> Int64 in
            return DogRepository.shared.currentDogs.first(where: { dog -> Bool in
                return dog.name == name
            })?.id ?? 0
        }).filter({ $0 != 0 })
        
        let requestData = CheckBookingPriceRequest(
            dogIds: dogIds,
            startDate: data.startDate,
            endDate: data.endDate,
            usePoint: data.point,
            couponCode: data.coupon)
        return provider.request(.check(id: booking.id, data: requestData))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> Booking in
                return BookingResponse.from(json: json).to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func updateStatus(booking: Booking, status: Booking.Status) -> Observable<Booking> {
        let requestData = UpdateBookingStatusRequest(status: status.rawValue)
        return provider.request(.updateStatus(id: booking.id, data: requestData))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> Booking in
                return BookingResponse.from(json: json).to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
}
