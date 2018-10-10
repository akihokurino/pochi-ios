//
//  UserApi.swift
//  pochi
//
//  Created by akiho on 2017/03/26.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum UserApi {
    case authenticate
    case create(data: CreateUserRequest)
    case update(id: String, data: UpdateUserRequest)
    case fetch(id: String)
    case fetchUploadImageUrl(id: String)
    case uploadImage(url: String, data: UploadImageRequest)
    case registerFcmToken(id: String, data: RegisterTokenRequest)
}

extension UserApi: BaseApi, TargetType {
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
        case .authenticate:
            return "/pochi/v1/users/login"
        case .create:
            return "/pochi/v1/users"
        case .update(let id, _):
            return "/pochi/v1/users/\(id)"
        case .fetch(let id):
            return "/pochi/v1/users/\(id)"
        case .fetchUploadImageUrl(let id):
            return "/pochi/v1/users/\(id)/image_upload"
        case .uploadImage:
            return ""
        case .registerFcmToken(let id, _):
            return "/pochi/v1/users/\(id)/devices"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .authenticate: fallthrough
        case .create: fallthrough
        case .uploadImage: fallthrough
        case .registerFcmToken:
            return .post
        case .update:
            return .put
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .create(let data):
            return data.toDictionary()
        case .update(_, let data):
            return data.toDictionary()
        case .registerFcmToken(_, let data):
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

extension UserApi: AccessTokenAuthorizable {
    var shouldAuthorize: Bool {
        switch self {
        default:
            return true
        }
    }
}

