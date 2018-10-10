//
//  DogApi.swift
//  pochi
//
//  Created by akiho on 2017/03/26.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum DogApi {
    case fetchAll(userId: String)
    case create(userId: String, data: CreateDogRequest)
    case update(userId: String, id: Int64, data: UpdateDogRequest)
    case fetchUploadImageUrl(userId: String, id: Int64)
    case uploadImage(url: String, data: UploadImageRequest)
}

extension DogApi: BaseApi, TargetType {
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
        case .fetchAll(let userId):
            return "/pochi/v1/users/\(userId)/dogs"
        case .create(let userId, _):
            return "/pochi/v1/users/\(userId)/dogs"
        case .update(let userId, let id, _):
            return "/pochi/v1/users/\(userId)/dogs/\(id)"
        case .fetchUploadImageUrl(let userId, let id):
            return "/pochi/v1/users/\(userId)/dogs/\(id)/image_upload"
        case .uploadImage:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .create: fallthrough
        case .uploadImage:
            return .post
        case .update:
            return .put
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .create(_, let data):
            return data.toDictionary()
        case .update(_, _, let data):
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

extension DogApi: AccessTokenAuthorizable {
    var shouldAuthorize: Bool {
        switch self {
        default:
            return true
        }
    }
}
