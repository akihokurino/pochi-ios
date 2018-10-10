//
//  RequestJsonParsable.swift
//  pochi
//
//  Created by akiho on 2017/03/31.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol RequestJsonParsable {
    func toDictionary() -> [String : Any]
}

extension RequestJsonParsable {
    func toJSON() -> JSON {
        let dic = toDictionary()
        return JSON(dic)
    }
}
