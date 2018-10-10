//
//  MessageApi.swift
//  pochi
//
//  Created by akiho on 2017/06/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum MessageApi {
    case fetchAll(bookingId: Int64, cursor: String?)
    case create(bookingId: Int64, data: CreateMessageRequest)
    case fetchUploadImageUrl(bookingId: Int64)
    case uploadImage(url: String, data: UploadImageRequest)
}

extension MessageApi: BaseApi, TargetType {
    var baseURL: URL {
        switch self {
        case .uploadImage(let url, _):
            return URL(string: url)!
        default:
            return URL(string: baseUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .fetchAll(let bookingId, _):
            return "/pochi/v1/bookings/\(bookingId)/messages"
        case .create(let bookingId, _):
            return "/pochi/v1/bookings/\(bookingId)/messages"
        case .fetchUploadImageUrl(let bookingId):
            return "/pochi/v1/bookings/\(bookingId)/messages/image_upload"
        case .uploadImage:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .create: fallthrough
        case .uploadImage:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .fetchAll(_, let cursor):
            if cursor != nil && !cursor!.isEmpty {
                return ["cursor": cursor!]
            } else {
                return nil
            }
        case .create(_, let data):
            return data.toDictionary()
        default:
            return nil
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
        switch self {
        case .uploadImage(_, let data):
            return .upload(.multipart([data.getMultipartFormData]))
        default:
            return .request
        }
    }
}

extension MessageApi: AccessTokenAuthorizable {
    var shouldAuthorize: Bool {
        switch self {
        default:
            return true
        }
    }
}
