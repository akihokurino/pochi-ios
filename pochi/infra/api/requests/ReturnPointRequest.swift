//
//  ReturnPointRequest.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ReturnPointRequest: RequestJsonParsable {
    let point: Int64
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["transferPoint"] = self.point
        return dictionary
    }
}
