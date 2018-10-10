//
//  UserProfileViewModel.swift
//  pochi
//
//  Created by akiho on 2017/07/03.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserProfileViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    private var reviews: Variable<[Review]> = Variable<[Review]>([])
    private var reviewPagination: Pagination<ItemsResponse<ReviewResponse>, ([Review], Int)>!
    private var stateReviewPagination: Variable<PaginationState> = Variable(PaginationState.hasNext)
    private var userDogs: Variable<[Dog]> = Variable([])
    private var reviewTotalCount: Variable<Int> = Variable(0)
    
    let user: User
    
    var observeReviews: Driver<[Review]> {
        return reviews.asDriver()
    }
    
    var observeUserDogs: Driver<[Dog]> {
        return userDogs.asDriver()
    }
    
    var observeStateReviewPagination: Driver<PaginationState> {
        return stateReviewPagination.asDriver()
    }
    
    var observeReviewTotalCount: Driver<Int> {
        return reviewTotalCount.asDriver()
    }
    
    init(user: User) {
        self.user = user
        
        reviewPagination = ReviewRepository.shared.fetchAll(user: user)
        reviewPagination!.subject.asObservable()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { result in
                self.stateReviewPagination.value = PaginationState.hasNext
                self.reviews.value.append(contentsOf: result.0)
                self.reviewTotalCount.value = result.1
            }, onError: { e in
                
            }, onCompleted: {
                self.stateReviewPagination.value = PaginationState.completed
            })
            .addDisposableTo(disposeBag)
        
        fetchReviewsEachPage()
        fetchUserDogs()
    }
    
    func fetchReviewsEachPage() {
        reviewPagination?.next()
    }
    
    private func fetchUserDogs() {
        DogRepository.shared.fetchAll(user: user.overview)
            .subscribe(onNext: { dogs in
                self.userDogs.value = dogs
            }, onError: { e in
                
            })
            .addDisposableTo(disposeBag)
    }
}