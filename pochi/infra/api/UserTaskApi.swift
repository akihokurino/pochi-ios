//
//  UserTaskApi.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum UserTaskApi {
    case fetchAll(sitterId: String)
    case updateReviewTask(bookingId: Int64, reviewId: Int64, data: UpdateReviewTaskRequest)
    case fetchUploadImageUrl(bookingId: Int64, id: Int64)
    case uploadImage(url: String, data: UploadImageRequest)
    case updateReportTask(bookingId: Int64, reportId: Int64, data: UpdateReportTaskRequest)
}

extension UserTaskApi: BaseApi, TargetType {
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
        case .fetchAll(let sitterId):
            return "/pochi/v1/hosts/\(sitterId)/tasks"
        case .updateReviewTask(let bookingId, let reviewId, _):
            return "/pochi/v1/bookings/\(bookingId)/reviews/\(reviewId)"
        case .fetchUploadImageUrl(let bookingId, let id):
            return "/pochi/v1/bookings/\(bookingId)/tasks/\(id)/image_upload"
        case .uploadImage:
            return ""
        case .updateReportTask(let bookingId, let reportId, _):
            return "/pochi/v1/bookings/\(bookingId)/tasks/\(reportId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .uploadImage:
            return .post
        case .updateReviewTask: fallthrough
        case .updateReportTask:
            return .put
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .updateReviewTask(_, _, let data):
            return data.toDictionary()
        case .updateReportTask(_, _, let data):
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

extension UserTaskApi: AccessTokenAuthorizable {
    var shouldAuthorize: Bool {
        switch self {
        default:
            return true
        }
    }
}


