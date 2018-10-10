//
//  PublicAssetsApi.swift
//  pochi
//
//  Created by akiho on 2017/03/22.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum PublicAssetApi {
    case fetchAll
}

extension PublicAssetApi: BaseApi, TargetType {
    var baseURL: URL {
        return URL(string: baseUrl)!
    }
    
    var path: String {
        switch self {
        case .fetchAll:
            return "/pochi/v1/public_assets"
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

extension PublicAssetApi: AccessTokenAuthorizable {
    var shouldAuthorize: Bool {
        switch self {
        default:
            return false
        }
    }
}
