//
//  ClosedKeepBookingListViewModel.swift
//  pochi
//
//  Created by akiho on 2017/08/16.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ClosedKeepBookingListViewModel {
    
    enum Event {
        case none
        case refreshed
        case empty
        case completedBookingPagination
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var bookingPagination: Pagination<ItemsResponse<BookingResponse>, [Booking]>
    private var bookings: Variable<[Booking]> = Variable([])
    private var event: Variable<Event> = Variable(.none)
    private var isRefreshing: Bool = false
    
    var observeEvent: Driver<Event> {
        return event.asDriver()
    }

    var observeBookings: Driver<[Booking]> {
        return bookings.asDriver()
    }
    
    init() {
        let appUser: AppUser = AppUserStore.shared.restore()!
        
        bookingPagination = BookingRepository.shared.fetchAllClosed(sitter: appUser)
        
        guard appUser.isSitter else {
            self.event.value = .empty
            return
        }
        
        observePagination()
        fetchBookingsEachPage()
    }
    
    private func observePagination() {
        bookingPagination.subject.asObservable()
            .do(onNext: { _ in
                if self.isRefreshing {
                    self.bookings.value = []
                    self.event.value = .refreshed
                    self.isRefreshing = false
                }
            })
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { items in
                self.bookings.value.append(contentsOf: items)
            }, onError: { e in
                
            }, onCompleted: {
                if self.bookings.value.isEmpty {
                    self.event.value = .empty
                }
                
                self.event.value = .completedBookingPagination
            })
            .addDisposableTo(disposeBag)
    }
    
    func fetchBookingsEachPage() {
        bookingPagination.next()
    }
    
    func refresh() {
        isRefreshing = true
        bookingPagination = bookingPagination.refresh()
        observePagination()
        fetchBookingsEachPage()
    }
}
