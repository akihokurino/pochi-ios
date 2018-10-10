//
//  ReviewApi.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum ReviewApi {
    case fetchAllOfBooking(bookingId: Int64, cursor: String?)
    case fetchAllOfUser(userId: String, cursor: String?)
    case fetchAllOfSitter(sitterId: String, cursor: String?)
    case create(bookingId: Int64, data: CreateReviewRequest)
}

extension ReviewApi: BaseApi, TargetType {
    var baseURL: URL {
        return URL(string: baseUrl)!
    }
    
    var path: String {
        switch self {
        case .fetchAllOfBooking(let bookingId, _):
            return "/pochi/v1/bookings/\(bookingId)/reviews"
        case .fetchAllOfUser(let userId, _):
            return "/pochi/v1/users/\(userId)/reviews"
        case .fetchAllOfSitter(let sitterId, _):
            return "/pochi/v1/hosts/\(sitterId)/reviews"
        case .create(let bookingId, _):
            return "/pochi/v1/bookings/\(bookingId)/reviews"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .create:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .fetchAllOfBooking(_, let cursor):
            if cursor != nil && !cursor!.isEmpty {
                return ["cursor": cursor!]
            } else {
                return nil
            }
        case .fetchAllOfUser(_, let cursor):
            if cursor != nil && !cursor!.isEmpty {
                return ["cursor": cursor!]
            } else {
                return nil
            }
        case .fetchAllOfSitter(_, let cursor):
            if cursor != nil && !cursor!.isEmpty {
                return ["cursor": cursor!]
            } else {
                return nil
            }
        case .create(_, let data):
            return data.toDictionary()
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
    
    var task: Task {
        return .request
    }
}

extension ReviewApi: AccessTokenAuthorizable {
    var shouldAuthorize: Bool {
        switch self {
        default:
            return true
        }
    }
}


