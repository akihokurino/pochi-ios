//
//  CreateDogRequest.swift
//  pochi
//
//  Created by akiho on 2017/03/31.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CreateDogRequest: RequestJsonParsable {
    let name: String
    let breed: String
    let gender: String
    let birthdate: String
    let size: String
   
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["name"] = self.name
        dictionary["breed"] = self.breed
        dictionary["gender"] = self.gender
        dictionary["birthdate"] = self.birthdate
        dictionary["size"] = self.size
        return dictionary
    }
}
