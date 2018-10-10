//
//  SitterDetailViewModel.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SitterDetailViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    private var reviews: Variable<[Review]> = Variable([])
    private var reviewPagination: Pagination<ItemsResponse<ReviewResponse>, ([Review], Int)>
    private var stateReviewPagination: Variable<PaginationState> = Variable(PaginationState.hasNext)
    
    private var sitter: Variable<Sitter?> = Variable(nil)
    private var sitterDogs: Variable<[Dog]> = Variable([])
    private var reviewTotalCount: Variable<Int> = Variable(0)
    
    private(set) var isRequesting: Bool = false
    
    var observeReviews: Driver<[Review]> {
        return reviews.asDriver()
    }
    
    var observeSitter: Driver<Sitter?> {
        return sitter.asDriver()
    }
    
    var observeSitterDogs: Driver<[Dog]> {
        return sitterDogs.asDriver()
    }
    
    var justSitter: Sitter {
        return sitter.value!
    }
    
    var observeStateReviewPagination: Driver<PaginationState> {
        return stateReviewPagination.asDriver()
    }
    
    var observeReviewTotalCount: Driver<Int> {
        return reviewTotalCount.asDriver()
    }
    
    init(sitter: Sitter) {
        self.sitter.value = sitter
        reviewPagination = ReviewRepository.shared.fetchAll(sitter: sitter)
        reviewPagination.subject.asObservable()
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
        
        SitterRepository.shared.fetch(id: sitter.overview.id)
            .subscribe(onNext: { sitter in
                self.sitter.value = sitter
            }, onError: { e in
                
            })
            .addDisposableTo(disposeBag)
        
        fetchSitterDogs()
    }
    
    func fetchReviewsEachPage() {
        reviewPagination.next()
    }

    func createBooking() -> Observable<Booking> {
        isRequesting = true
        return BookingRepository.shared.create(sitter: sitter.value!)
            .do(onNext: { _ in
                self.isRequesting = false
            }, onError: { e in
                self.isRequesting = false
            })
    }
    
    private func fetchSitterDogs() {
        DogRepository.shared.fetchAll(user: justSitter.overview)
            .subscribe(onNext: { dogs in
                self.sitterDogs.value = dogs
            }, onError: { e in
                
            })
            .addDisposableTo(disposeBag)
    }
}

