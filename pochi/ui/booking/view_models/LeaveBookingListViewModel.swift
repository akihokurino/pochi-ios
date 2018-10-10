//
//  LeaveBookingListViewModel.swift
//  pochi
//
//  Created by akiho on 2017/07/21.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// ユーザーとして預ける
class LeaveBookingListViewModel {
    
    enum Event {
        case none
        case refreshed
        case empty
        case completedBookingPagination
    }
    
    enum Segment: Int, EnumEnumerable {
        case requesting = 0
        case accepted = 1
        case leaving = 2
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var bookings: Variable<[Booking]> = Variable([])
    private var event: Variable<Event> = Variable(.none)
    private var isRefreshing: Bool = false
    private var bookingPagination: Pagination<ItemsResponse<BookingResponse>, [Booking]>?
    
    var currentSegment: Segment = Segment.requesting
    
    var observeBookings: Driver<[Booking]> {
        return bookings.asDriver()
    }
    
    var observeEvent: Driver<Event> {
        return event.asDriver()
    }
    
    // ViewWillAppearで呼ぶ
    func fetchAll() {
        guard let appUser = AppUserStore.shared.restore() else {
            return
        }
        
        bookings.value = []
        
        fetchAll(appUser: appUser)
    }
    
    func refresh() {
        guard let appUser = AppUserStore.shared.restore() else {
            return
        }
        
        isRefreshing = true
        
        fetchAll(appUser: appUser)
    }
    
    private func fetchAll(appUser: AppUser) {
        var allBookings: [Booking] = []
        bookingPagination = BookingRepository.shared.fetchAll(user: appUser)
        bookingPagination?.subject
            .subscribe(onNext: { bookings in
                allBookings.append(contentsOf: bookings)
                self.bookingPagination?.next()
            }, onError: { e in
                
            }, onCompleted: {
                if self.isRefreshing {
                    self.bookings.value = []
                    self.event.value = .refreshed
                    self.isRefreshing = false
                }
                
                switch self.currentSegment {
                case .requesting:
                    self.filterAllRequesting(items: allBookings)
                case .accepted:
                    self.filterAllAccepted(items: allBookings)
                case .leaving:
                    self.filterAllLeaving(items: allBookings)
                }
                
                if self.bookings.value.isEmpty {
                    self.event.value = .empty
                }
                
                self.event.value = .completedBookingPagination
            })
            .addDisposableTo(disposeBag)
        
        bookingPagination?.next()
    }

    private func filterAllRequesting(items: [Booking]) {
        self.bookings.value = items.filter({
            $0.status == .prerequest || $0.status == .request || $0.status == .refuse || $0.status == .cancel
        })
    }
    
    private func filterAllAccepted(items: [Booking]) {
        self.bookings.value = items.filter({ $0.status == .confirm })
    }
    
    private func filterAllLeaving(items: [Booking]) {
        self.bookings.value = items.filter({ $0.status == .stay })
    }
}

