//
//  ReportTaskViewModel.swift
//  pochi
//
//  Created by akiho on 2017/08/27.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ReportTaskViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    private(set) var reportData: ReportTaskData = ReportTaskData(image: nil, content: "")
    let task: UserTask
    private(set) var isLoading: Bool = false
   
    init(task: UserTask) {
        self.task = task
    }
    
    func sync(image: UIImage) {
        self.reportData = ReportTaskData(image: image, content: reportData.content)
    }
    
    func sync(content: String) {
        self.reportData = ReportTaskData(image: reportData.image, content: content)
    }
    
    func create() -> Observable<Void> {
        isLoading = true
        return UserTaskRepository.shared.update(task: task, data: reportData)
            .do(onNext: {
                self.isLoading = false
            }, onError: { e in
                self.isLoading = false
            })
    }
}
