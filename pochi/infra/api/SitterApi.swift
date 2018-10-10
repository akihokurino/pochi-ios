//
//  SitterApi.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum SitterApi {
    case fetchAll(cursor: String?)
    case search(zipCode: String, cursor: String?)
    case fetch(id: String)
}

extension SitterApi: BaseApi, TargetType {
    var baseURL: URL {
        return URL(string: baseUrl)!
    }
    
    var path: String {
        switch self {
        case .fetchAll:
            return "/pochi/v1/hosts"
        case .search:
            return "/pochi/v1/hosts"
        case .fetch(let id):
            return "/pochi/v1/hosts/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .fetchAll(let cursor):
            if cursor != nil && !cursor!.isEmpty {
                return ["cursor": cursor!]
            } else {
                return nil
            }
        case .search(let zipCode, let cursor):
            if cursor != nil && !cursor!.isEmpty {
                return ["cursor": cursor!, "zipCode": zipCode]
            } else {
                return ["zipCode": zipCode]
            }
        default:
            return nil
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding {
        switch self {
        case .fetchAll: fallthrough
        case .search:
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

extension SitterApi: AccessTokenAuthorizable {
    var shouldAuthorize: Bool {
        switch self {
        default:
            return true
        }
    }
}


