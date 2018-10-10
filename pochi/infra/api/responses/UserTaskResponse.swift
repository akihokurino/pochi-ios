//
//  UserTaskResponse.swift
//  pochi
//
//  Created by akiho on 2017/07/02.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserTaskResponse: ResponseJsonParsable {
    let id: Int64
    let bookingId: Int64
    let type: String
    let status: String
    let date: String
    let title: String
    let forReviewTask: ForReviewTaskResponse?
    let forDailyReportTask: ForDailyReportTaskResponse?
    
    static func from(json: JSON!) -> UserTaskResponse {
        return UserTaskResponse(id: json["id"].int64Value,
                                bookingId: json["bookingId"].int64Value,
                                type: json["type"].stringValue,
                                status: json["status"].stringValue,
                                date: json["date"].stringValue,
                                title: json["title"].stringValue,
                                forReviewTask: !json["forReviewTask"].isEmpty ? ForReviewTaskResponse.from(json: json["forReviewTask"]) : nil,
                                forDailyReportTask: !json["forDailyReportTask"].isEmpty ? ForDailyReportTaskResponse.from(json: json["forDailyReportTask"]) : nil)
    }
    
    func to() -> UserTask {
        return UserTask(id: id,
                        bookingId: bookingId,
                        rawType: type,
                        rawStatus: status,
                        date: date,
                        title: title,
                        forReviewTask: forReviewTask?.to(),
                        forReportTask: forDailyReportTask?.to())
    }
}

struct ForReviewTaskResponse: ResponseJsonParsable {
    let revieweeId: String
    
    static func from(json: JSON!) -> ForReviewTaskResponse {
        return ForReviewTaskResponse(revieweeId: json["revieweeId"].stringValue)
    }
    
    func to() -> ForReviewTask {
        return ForReviewTask(revieweeId: revieweeId)
    }
}

struct ForDailyReportTaskResponse: ResponseJsonParsable {
    let dogId: Int64
    let imageUrl: String
    let comment: String
    
    static func from(json: JSON!) -> ForDailyReportTaskResponse {
        return ForDailyReportTaskResponse(dogId: json["dogId"].int64Value,
                                          imageUrl: json["imageUrl"].stringValue,
                                          comment: json["comment"].stringValue)
    }
    
    func to() -> ForDailyReportTask {
        return ForDailyReportTask(dogId: dogId, imageUrl: imageUrl, comment: comment)
    }
}
