//
//  BankApi.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

// https://bank.teraren.com/
enum BankApi {
    case fetchAll
    case fetchBank(bankCode: String)
    case fetchBranch(bankCode: String, branchCode: String)
}

extension BankApi: BaseApi, TargetType {
    var baseURL: URL {
        return URL(string: AppConfig.bankEndpoint)!
    }
    
    var path: String {
        switch self {
        case .fetchAll:
            return "/banks.json"
        case .fetchBank(let bankCode):
            return "/banks/\(bankCode).json"
        case .fetchBranch(let bankCode, let branchCode):
            return "/banks/\(bankCode)/branches/\(branchCode).json"
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
