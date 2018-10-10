//
//  ItemsResponse.swift
//  pochi
//
//  Created by akiho on 2017/06/30.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ItemsResponse<T: ResponseJsonParsable>: ResponseJsonParsable, HasPointer {
    let pointer: Pointer!
    let items: [T]
    let totalCount: Int?
    
    static func from(json: JSON!) -> ItemsResponse {
        return ItemsResponse(pointer: Pointer.from(json: json),
                             items: json["items"].arrayValue.map({ T.from(json: $0) }),
                             totalCount: json["totalCount"].int)
    }
}
