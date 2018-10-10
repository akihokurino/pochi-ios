//
//  BankAccountApi.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum BankAccountApi {
    case fetchAll(userId: String)
    case create(userId: String, data: CreateBankAccountRequest)
    case transfer(userId: String, bankAccountId: String, data: ReturnPointRequest)
}

extension BankAccountApi: BaseApi, TargetType {
    var baseURL: URL {
        return URL(string: baseUrl)!
    }
    
    var path: String {
        switch self {
        case .fetchAll(let userId):
            return "/pochi/v1/users/\(userId)/banks"
        case .create(let userId, _):
            return "/pochi/v1/users/\(userId)/banks"
        case .transfer(let userId, let bankAccountId, _):
            return "/pochi/v1/users/\(userId)/banks/\(bankAccountId)/transfer"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .create: fallthrough
        case .transfer:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .create(_, let data):
            return data.toDictionary()
        case .transfer(_, _, let data):
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
        return .request
    }
}

extension BankAccountApi: AccessTokenAuthorizable {
    var shouldAuthorize: Bool {
        switch self {
        default:
            return true
        }
    }
}
