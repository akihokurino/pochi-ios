//
//  PublicAssetRepository.swift
//  pochi
//
//  Created by akiho on 2017/03/25.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

class PublicAssetRepository {
    static let shared = PublicAssetRepository()
    
    private let provider = RxMoyaProvider<PublicAssetApi>()
    private(set) var dogBreedTypes: [Asset] = []
    private(set) var dogGenderTypes: [Asset] = []
    private(set) var dogAttributes: [Asset] = []
    private(set) var dogSizeTypes: [Asset] = []
    private(set) var dogKeepingStyles: [Asset] = []
    private(set) var houseTypes: [Asset] = []
    private(set) var kidsTypes: [Asset] = []
    private(set) var options: [Asset] = []
    private(set) var smokingPolicies: [Asset] = []
    private(set) var walkingPolicies: [Asset] = []
    
    private init() {
        
    }
    
    func setup() -> Observable<Void> {
        return provider.request(.fetchAll)
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> PublicAssetResponse in
                let response = PublicAssetResponse.from(json: json)
                self.dogBreedTypes = response.dogBreedTypes.map { $0.to() }
                self.dogGenderTypes = response.dogGenderTypes.map { $0.to() }
                self.dogAttributes = response.dogAttributes.map { $0.to() }
                self.dogSizeTypes = response.dogSizeTypes.map { $0.to() }
                self.dogKeepingStyles = response.dogKeepingStyles.map { $0.to() }
                self.houseTypes = response.houseTypes.map { $0.to() }
                self.kidsTypes = response.kidsTypes.map { $0.to() }
                self.options = response.options.map { $0.to() }
                self.smokingPolicies = response.smokingPolicies.map { $0.to() }
                self.walkingPolicies = response.walkingPolicies.map { $0.to() }
                return response
            })
            .map({ _ -> Void in
                
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    struct Asset {
        let label: String
        let value: String
    }
}
