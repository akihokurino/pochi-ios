//
//  UserTaskGroupResponse.swift
//  pochi
//
//  Created by akiho on 2017/08/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserTaskGroupResponse: ResponseJsonParsable {
    let items: [UserTasksWithDateResponse]
    
    static func from(json: JSON!) -> UserTaskGroupResponse {
        let map = json["items"].dictionaryValue
        var items: [UserTasksWithDateResponse] = []
        for key in map.keys.sorted() {
            items.append(UserTasksWithDateResponse(
                date: key,
                tasks: map[key]!.arrayValue.map({ UserTaskResponse.from(json: $0) }))
            )
        }
        return UserTaskGroupResponse(items: items)
    }
}

struct UserTasksWithDateResponse {
    let date: String
    let tasks: [UserTaskResponse]
    
    func to() -> UserTaskWithSection {
        return UserTaskWithSection(header: date, items: tasks.map({ $0.to() }))
    }
}
