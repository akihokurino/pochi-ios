//
//  MessageRepository.swift
//  pochi
//
//  Created by akiho on 2017/06/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

class MessageRepository: ProvideTokenProtocol {
    static let shared = MessageRepository()
    
    private var provider: RxMoyaProvider<MessageApi> {
        return RxMoyaProvider<MessageApi>(plugins: [authPlugin])
    }
    
    private init() {
        
    }
    
    func fetchAll(booking: Booking) -> Pagination<ItemsResponse<MessageResponse>, [Message]> {
        return Pagination<ItemsResponse<MessageResponse>, [Message]>(
            load: { cursor in
                return self.provider.request(.fetchAll(bookingId: booking.id, cursor: cursor))
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> ItemsResponse<MessageResponse> in
                        return ItemsResponse<MessageResponse>.from(json: json)
                    })
            },
            convert: { response -> [Message] in
                return response.items.map({ $0.to() })
            }
        )
    }
    
    func create(booking: Booking, data: CreateMessageData) -> Observable<Message> {
        let requestData: CreateMessageRequest =
            CreateMessageRequest(from: AppUserStore.shared.restore()!.overview.id,
                                 content: data.content)
        
        return provider.request(.create(bookingId: booking.id, data: requestData))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> Message in
                return MessageResponse.from(json: json).to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func create(booking: Booking, image: UIImage) -> Observable<Message> {
        return provider.request(.fetchUploadImageUrl(bookingId: booking.id))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> String in
                return UploadImageUrlResponse.from(json: json).url
            })
            .flatMap({ url -> Observable<Message> in
                let uploadData = UploadImageRequest(image: image, format: .jpeg)
                return self.provider.request(.uploadImage(url: url, data: uploadData))
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> Message in
                        return MessageResponse.from(json: json).to()
                    })
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
}
