//
//  AddressResponse.swift
//  pochi
//
//  Created by akiho on 2017/08/16.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AddressResponse: ResponseJsonParsable {
    let latitude: Double
    let longitude: Double
    let zipCode: String
    let address: String
    
    static func from(json: JSON!) -> AddressResponse {
        return AddressResponse(latitude: json["latitude"].doubleValue,
                               longitude: json["longitude"].doubleValue,
                               zipCode: json["zipCode"].stringValue,
                               address: json["address"].stringValue)
    }
    
    func to() -> Address {
        return Address(latitude: self.latitude,
                       longitude: self.longitude,
                       zipCode: self.zipCode,
                       address: self.address)
    }
}
