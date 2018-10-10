//
//  SearchResultViewModel.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchResultViewModel {
    enum Event {
        case none
        case invalidPostalCode
        case empty
        case completedSitterPagination
    }

    private let disposeBag: DisposeBag = DisposeBag()
    private var sittersPagination: Pagination<ItemsResponse<SitterResponse>, [Sitter]>?
    private var sitters: Variable<[Sitter]> = Variable([])
    private var event: Variable<Event> = Variable(.none)
    
    private(set) var currentZipCode: String = ""
    var selectedSitter: Sitter? = nil
    
    var observeSitters: Driver<[Sitter]> {
        return sitters.asDriver()
    }
    
    var observeEvent: Driver<Event> {
        return event.asDriver()
    }

    func search(zipCode: String) {
        self.currentZipCode = zipCode
        self.sitters.value = []
        
        sittersPagination?.destroy()
        sittersPagination = SitterRepository.shared.fetchSearchResult(zipCode: zipCode)
        sittersPagination!.subject.asObservable()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { items in
                self.sitters.value.append(contentsOf: items)
            }, onError: { e in
                // エラーメッセージの取り方がいまいちわからないので一旦。。。
                if (e as NSError).code == 400 {
                    self.event.value = .invalidPostalCode
                }
            }, onCompleted: {
                if self.sitters.value.isEmpty {
                    self.event.value = .empty
                }
                
                self.event.value = .completedSitterPagination
            })
            .addDisposableTo(disposeBag)
        
        fetchSittersEachPage()
    }
    
    func fetchSittersEachPage() {
        sittersPagination?.next()
    }
}

