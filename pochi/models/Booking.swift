//
//  Booking.swift
//  pochi
//
//  Created by akiho on 2017/04/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class Booking {
    enum Status: String {
        case prerequest = "PREREQUEST"
        case request = "REQUEST"
        case refuse = "REFUSE"
        case confirm = "CONFIRM"
        case cancel = "CANCEL"
        case stay = "STAY"
        case completion = "COMPLETION"
        case close = "CLOSE"
    }
    
    let id: Int64
    let user: UserOverview
    let sitter: UserOverview
    let dogIds: [Int64]
    let status: Status
    let startDate: String?
    let endDate: String?
    let days: Int?
    let unitPrice: Int
    let totalPrice: Int
    let totalChargePrice: Int
    let usePoint: Int
    let useCouponCode: Int64?
    let message: Message?
    let isUserReviewed: Bool
    let isSitterReviewed: Bool
    let maxRewardPoint: Int
    let createdAt: Int64
    let updatedAt: Int64
    
    var isValidForRequest: Bool {
        return !dogIds.isEmpty && startDate != nil && endDate != nil
    }
    
    var hasCoupon: Bool {
        return useCouponCode != nil
    }

    init(id: Int64,
         user: UserOverview,
         sitter: UserOverview,
         dogIds: [Int64],
         rawStatus: String,
         startDate: String?,
         endDate: String?,
         days: Int?,
         unitPrice: Int,
         totalPrice: Int,
         totalChargePrice: Int,
         usePoint: Int,
         useCouponCode: Int64?,
         message: Message?,
         isUserReviewed: Bool,
         isSitterReviewed: Bool,
         maxRewardPoint: Int,
         createdAt: Int64,
         updatedAt: Int64) {
        self.id = id
        self.user = user
        self.sitter = sitter
        self.dogIds = dogIds
        self.status = Status(rawValue: rawStatus)!
        self.startDate = startDate
        self.endDate = endDate
        self.days = days
        self.unitPrice = unitPrice
        self.totalPrice = totalPrice
        self.totalChargePrice = totalChargePrice
        self.usePoint = usePoint
        self.useCouponCode = useCouponCode
        self.message = message
        self.isUserReviewed = isUserReviewed
        self.isSitterReviewed = isSitterReviewed
        self.maxRewardPoint = maxRewardPoint
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
