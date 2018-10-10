//
//  SearchViewModel.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    enum Event {
        case none
        case completedSitterPagination
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let sitterPagination: Pagination<ItemsResponse<SitterResponse>, [Sitter]> = SitterRepository.shared.fetchAll()
    private var sitters: Variable<[Sitter]> = Variable([])
    private var histories: Variable<[Sitter]> = Variable([])
    private var event: Variable<Event> = Variable(.none)
    
    var observeEvent: Driver<Event> {
        return event.asDriver()
    }
    
    var observeSitters: Driver<[Sitter]> {
        return sitters.asDriver()
    }
    
    var observeHistories: Driver<[Sitter]> {
        return histories.asDriver()
    }
    
    var selectedSitter: Sitter? = nil
    var currentZipcode: String = ""
    
    init() {
        sitterPagination.subject.asObservable()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { items in
                self.sitters.value.append(contentsOf: items)
            }, onError: { e in
                
            }, onCompleted: {
                self.event.value = .completedSitterPagination
            })
            .addDisposableTo(disposeBag)
        
        fetchSittersEachPage()
        fetchHistories()
    }
    
    func fetchSittersEachPage() {
        sitterPagination.next()
    }
    
    private func fetchHistories() {
        SitterRepository.shared.fetchHistory()
            .subscribe(onNext: { items in
                self.histories.value.append(contentsOf: items)
            }, onError: { e in
                
            })
            .addDisposableTo(disposeBag)
    }
}

