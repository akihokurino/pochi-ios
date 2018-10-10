//
//  PetService.swift
//  pochi
//
//  Created by akiho on 2017/01/07.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

class DogRepository: ProvideTokenProtocol {
    static let shared = DogRepository()
    
    private var provider: RxMoyaProvider<DogApi> {
        return RxMoyaProvider<DogApi>(plugins: [authPlugin])
    }
    
    private(set) var currentDogs: [Dog] = []
    
    private init() {
        
    }
    
    func fetchAll(user: UserOverview) -> Observable<[Dog]> {
        return provider.request(.fetchAll(userId: user.id))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> [Dog] in
                self.currentDogs = ItemsResponse<DogResponse>.from(json: json).items.map({ $0.to() })
                return self.currentDogs
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func create(user: AppUser, data: CreateDogData.SendData) -> Observable<Dog> {
        let requestData = CreateDogRequest(name: data.name,
                                           breed: data.breed,
                                           gender: data.gender,
                                           birthdate: data.birthdate,
                                           size: data.size)
        
        return provider.request(.create(userId: user.overview.id, data: requestData))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> Dog in
                let response = DogResponse.from(json: json)
                return response.to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func update(dog: Dog, data: EditDogData.SendData) -> Observable<Dog> {
        let appUser: AppUser = AppUserStore.shared.restore()!
        let requestData = UpdateDogRequest(name: data.name,
                                           breed: data.breed,
                                           gender: data.gender,
                                           birthdate: data.birthdate,
                                           size: data.size)
        
        return provider.request(.update(userId: appUser.overview.id, id: dog.id, data: requestData))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> Dog in
                return DogResponse.from(json: json).to()
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func updateIcon(dog: Dog, image: UIImage) -> Observable<Dog> {
        let appUser: AppUser = AppUserStore.shared.restore()!
        return provider.request(.fetchUploadImageUrl(userId: appUser.overview.id, id: dog.id))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> String in
                return UploadImageUrlResponse.from(json: json).url
            })
            .flatMap({ url -> Observable<Dog> in
                let uploadData = UploadImageRequest(image: image, format: .jpeg)
                return self.provider.request(.uploadImage(url: url, data: uploadData))
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> Dog in
                        return DogResponse.from(json: json).to()
                    })
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
}
