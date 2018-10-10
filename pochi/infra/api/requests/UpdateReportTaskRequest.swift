//
//  UpdateReportTaskRequest.swift
//  pochi
//
//  Created by akiho on 2017/08/27.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UpdateReportTaskRequest: RequestJsonParsable {
    let comment: String
    
    func toDictionary() -> [String : Any] {
        var dictionary: [String : Any] = [:]
        dictionary["comment"] = self.comment
        return dictionary
    }
}
