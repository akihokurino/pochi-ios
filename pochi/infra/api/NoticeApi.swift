//
//  NoticeApi.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum NoticeApi {
    case fetchAll
}

extension NoticeApi: BaseApi, TargetType {
    var baseURL: URL {
        return URL(string: baseUrl)!
    }
    
    var path: String {
        switch self {
        case .fetchAll:
            return ""
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
        return .request
    }
}

extension NoticeApi: AccessTokenAuthorizable {
    var shouldAuthorize: Bool {
        switch self {
        default:
            return true
        }
    }
}


