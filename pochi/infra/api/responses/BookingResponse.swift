//
//  BookingResponse.swift
//  pochi
//
//  Created by akiho on 2017/07/01.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BookingResponse: ResponseJsonParsable {
    let id: Int64
    let user: UserOverviewResponse
    let sitter: UserOverviewResponse
    let dogIds: [Int64]
    let status: String
    let startDate: String?
    let endDate: String?
    let days: Int?
    let unitPrice: Int
    let totalPrice: Int
    let totalChargePrice: Int
    let usePoint: Int
    let useCouponCode: Int64?
    let message: MessageResponse?
    let isUserReviewed: Bool
    let isSitterReviewed: Bool
    let maxRewardPoint: Int
    let createdAt: Int64
    let updatedAt: Int64
    
    static func from(json: JSON!) -> BookingResponse {
        return BookingResponse(id: json["id"].int64Value,
                               user: UserOverviewResponse.from(json: json["user"]),
                               sitter: UserOverviewResponse.from(json: json["host"]),
                               dogIds: json["dogIds"].arrayValue.map({ $0.int64Value }),
                               status: json["status"].stringValue,
                               startDate: json["startDate"].string,
                               endDate: json["endDate"].string,
                               days: json["days"].int,
                               unitPrice: json["unitPrice"].intValue,
                               totalPrice: json["totalPrice"].intValue,
                               totalChargePrice: json["totalChargePrice"].intValue,
                               usePoint: json["usePoint"].intValue,
                               useCouponCode: json["couponCode"].int64,
                               message: !json["message"].isEmpty ? MessageResponse.from(json: json["message"]) : nil,
                               isUserReviewed: json["isUserReviewed"].boolValue,
                               isSitterReviewed: json["isSitterReviewed"].boolValue,
                               maxRewardPoint: json["maxRewardPoint"].intValue,
                               createdAt: json["createdAt"].int64Value,
                               updatedAt: json["updatedAt"].int64Value)
    }
    
    func to() -> Booking {
        return Booking(id: id,
                       user: user.to(),
                       sitter: sitter.to(),
                       dogIds: dogIds,
                       rawStatus: status,
                       startDate: startDate,
                       endDate: endDate,
                       days: days,
                       unitPrice: unitPrice,
                       totalPrice: totalPrice,
                       totalChargePrice: totalChargePrice,
                       usePoint: usePoint,
                       useCouponCode: useCouponCode,
                       message: message?.to(),
                       isUserReviewed: isUserReviewed,
                       isSitterReviewed: isSitterReviewed,
                       maxRewardPoint: maxRewardPoint,
                       createdAt: createdAt,
                       updatedAt: updatedAt)
    }
}
