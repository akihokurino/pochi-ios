//
//  Address.swift
//  pochi
//
//  Created by akiho on 2017/08/16.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class Address {
    let latitude: Double
    let longitude: Double
    let zipCode: String
    let address: String
    
    init(latitude: Double, longitude: Double, zipCode: String, address: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.zipCode = zipCode
        self.address = address
    }
}

