//
//  BookingApi.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum BookingApi {
    case fetchAllOfUser(userId: String, cursor: String?)
    case fetchAllOfSitter(sitterId: String, cursor: String?)
    case fetchAllClosedOfUser(userId: String, cursor: String?)
    case fetchAllClosedOfSitter(sitterId: String, cursor: String?)
    case create(data: CreateBookingRequest)
    case request(id: Int64, data: UpdateBookingRequest)
    case updateStatus(id: Int64, data: UpdateBookingStatusRequest)
    case check(id: Int64, data: CheckBookingPriceRequest)
}

extension BookingApi: BaseApi, TargetType {
    var baseURL: URL {
        return URL(string: baseUrl)!
    }
    
    var path: String {
        switch self {
        case .fetchAllOfUser(let userId, _):
            return "/pochi/v1/users/\(userId)/bookings"
        case .fetchAllOfSitter(let sitterId, _):
            return "/pochi/v1/hosts/\(sitterId)/bookings"
        case .fetchAllClosedOfUser(let userId, _):
            return "/pochi/v1/users/\(userId)/bookings/closed"
        case .fetchAllClosedOfSitter(let sitterId, _):
            return "/pochi/v1/hosts/\(sitterId)/bookings/closed"
        case .create:
            return "/pochi/v1/bookings"
        case .request(let id, _):
            return "/pochi/v1/bookings/\(id)/request"
        case .updateStatus(let id, _):
            return "/pochi/v1/bookings/\(id)/update_status"
        case .check(let id, _):
            return "/pochi/v1/bookings/\(id)/check"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .create:
            return .post
        case .request: fallthrough
        case .updateStatus: fallthrough
        case .check:
            return .put
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
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
        case .fetchAllClosedOfUser(_, let cursor):
            if cursor != nil && !cursor!.isEmpty {
                return ["cursor": cursor!]
            } else {
                return nil
            }
        case .fetchAllClosedOfSitter(_, let cursor):
            if cursor != nil && !cursor!.isEmpty {
                return ["cursor": cursor!]
            } else {
                return nil
            }
        case .create(let data):
            return data.toDictionary()
        case .request(_, let data):
            return data.toDictionary()
        case .updateStatus(_, let data):
            return data.toDictionary()
        case .check(_, let data):
            return data.toDictionary()
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .fetchAllOfUser: fallthrough
        case .fetchAllOfSitter: fallthrough
        case .fetchAllClosedOfUser: fallthrough
        case .fetchAllClosedOfSitter:
            return URLEncoding.default
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

extension BookingApi: AccessTokenAuthorizable {
    var shouldAuthorize: Bool {
        switch self {
        default:
            return true
        }
    }
}

