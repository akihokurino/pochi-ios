//
//  ReviewTaskViewModel.swift
//  pochi
//
//  Created by akiho on 2017/08/27.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ReviewTaskViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    private(set) var reviewData: ReviewTaskData = ReviewTaskData(score: 0, content: "")
    let task: UserTask
    private(set) var isLoading: Bool = false
    private var reviewee: Variable<User?> = Variable(nil)
    
    var observeReviewee: Driver<User?> {
        return reviewee.asDriver()
    }
    
    init(task: UserTask) {
        self.task = task
        fetchReviewee()
    }
    
    func sync(score: Int) {
        self.reviewData = ReviewTaskData(score: score, content: reviewData.content)
    }
    
    func sync(content: String) {
        self.reviewData = ReviewTaskData(score: reviewData.score, content: content)
    }
    
    func create() -> Observable<Void> {
        isLoading = true
        return UserTaskRepository.shared.update(task: task, data: reviewData)
            .do(onNext: {
                self.isLoading = false
            }, onError: { e in
                self.isLoading = false
            })
    }
    
    private func fetchReviewee() {
        UserRepository.shared.fetch(id: task.forReviewTask!.revieweeId)
            .subscribe(onNext: { user in
                self.reviewee.value = user
            }, onError: { e in
                
            })
            .addDisposableTo(disposeBag)
    }
}
