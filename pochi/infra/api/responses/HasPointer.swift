//
//  HasCursor.swift
//  pochi
//
//  Created by akiho on 2017/07/15.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol HasPointer {
    var pointer: Pointer! { get }
}

struct Pointer: ResponseJsonParsable {
    let nextCursor: String
    
    /// 次のページがあるかの判定
    var hasNext : Bool {
        return !nextCursor.isEmpty
    }
    
    static func from(json: JSON!) -> Pointer {
        return Pointer(nextCursor: json["nextCursor"].stringValue)
    }
}
