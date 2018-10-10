//
//  UserTaskRepository.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

class UserTaskRepository: ProvideTokenProtocol {
    static let shared = UserTaskRepository()
    
    private var provider: RxMoyaProvider<UserTaskApi> {
        return RxMoyaProvider<UserTaskApi>(plugins: [authPlugin])
    }
    
    private init() {
        
    }
    
    func fetchAll() -> Observable<[UserTaskWithSection]> {
        return provider.request(.fetchAll(sitterId: AppUserStore.shared.restore()!.overview.id))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> [UserTaskWithSection] in
                return UserTaskGroupResponse.from(json: json).items.map({ $0.to() })
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func update(task: UserTask, data: ReviewTaskData) -> Observable<Void> {
        let requestData = UpdateReviewTaskRequest(score: data.score, content: data.content)
        return provider.request(.updateReviewTask(bookingId: task.bookingId, reviewId: task.id, data: requestData))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> Void in
                
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }
    
    func update(task: UserTask, data: ReportTaskData) -> Observable<Void> {
        return provider.request(.fetchUploadImageUrl(bookingId: task.bookingId, id: task.id))
            .filterError()
            .retryIfError()
            .convertToJsonObservable()
            .map({ json -> String in
                return UploadImageUrlResponse.from(json: json).url
            })
            .flatMap({ url -> Observable<Void> in
                let uploadData = UploadImageRequest(image: data.image!, format: .jpeg)
                return self.provider.request(.uploadImage(url: url, data: uploadData))
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> Void in
                        
                    })
            })
            .flatMap({ _ -> Observable<Void> in
                let requestData = UpdateReportTaskRequest(comment: data.content)
                return self.provider.request(.updateReportTask(bookingId: task.bookingId, reportId: task.id, data: requestData))
                    .filterError()
                    .retryIfError()
                    .convertToJsonObservable()
                    .map({ json -> Void in
                        
                    })
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
    }

}
