//
//  BookingActionViewModel.swift
//  pochi
//
//  Created by akiho on 2017/10/18.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BookingActionViewModel {
    
    let appUser: AppUser = AppUserStore.shared.restore()!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private(set) var sitter: Sitter?
    private(set) var user: User?
    private(set) var isRequesting: Bool = false
    private(set) var booking: Booking
    private var userDogs: Variable<[Dog]> = Variable<[Dog]>([])
    private var coupon: Variable<Coupon?> = Variable(nil)
    
    var isOpen: Bool = false
    
    var isSitter: Bool {
        return booking.sitter.id == appUser.overview.id
    }
    
    var observeUserDogs: Driver<[Dog]> {
        return self.userDogs.asDriver()
    }
    
    var observeCoupon: Driver<Coupon> {
        return self.coupon.asDriver().filter({ $0 != nil }).map({ $0! })
    }
    
    init(booking: Booking) {
        self.booking = booking
        
        fetchSitter()
        fetchUser()
        
        fetchUserDogs()
        if booking.hasCoupon {
            fetchCoupon()
        }
    }
    
    func requestBooking(cardToken: String) -> Observable<Booking> {
        self.isRequesting = true
        return BookingRepository.shared.request(
            booking: booking,
            cardToken: cardToken)
            .do(onNext: { booking in
                self.isRequesting = false
                self.booking = booking
            }, onError: { e in
                self.isRequesting = false
            })
    }
    
    func cancelBooking() -> Observable<Booking> {
        self.isRequesting = true
        return BookingRepository.shared.updateStatus(booking: booking, status: .cancel)
            .do(onNext: { booking in
                self.isRequesting = false
                self.booking = booking
            }, onError: { e in
                self.isRequesting = false
            })
    }
    
    func acceptBooking() -> Observable<Booking> {
        self.isRequesting = true
        return BookingRepository.shared.updateStatus(booking: booking, status: .confirm)
            .do(onNext: { booking in
                self.isRequesting = false
                self.booking = booking
            }, onError: { e in
                self.isRequesting = false
            })
    }
    
    func rejectBooking() -> Observable<Booking> {
        self.isRequesting = true
        return BookingRepository.shared.updateStatus(booking: booking, status: .refuse)
            .do(onNext: { booking in
                self.isRequesting = false
                self.booking = booking
            }, onError: { e in
                self.isRequesting = false
            })
    }
    
    private func fetchSitter() {
        SitterRepository.shared.fetch(id: booking.sitter.id)
            .subscribe(onNext: { sitter in
                self.sitter = sitter
            }, onError: { e in
                
            })
            .addDisposableTo(disposeBag)
    }
    
    private func fetchUser() {
        UserRepository.shared.fetch(id: booking.user.id)
            .subscribe(onNext: { user in
                self.user = user
            }, onError: { e in
                
            })
            .addDisposableTo(disposeBag)
    }
    
    private func fetchUserDogs() {
        DogRepository.shared.fetchAll(user: booking.user)
            .subscribe(onNext: { dogs in
                self.userDogs.value = dogs
            }, onError: { e in
                
            })
            .addDisposableTo(disposeBag)
    }
    
    private func fetchCoupon() {
        CouponRepository.shared.fetch(code: booking.useCouponCode!)
            .subscribe(onNext: { coupon in
                self.coupon.value = coupon
            }, onError: { e in
                
            })
            .addDisposableTo(disposeBag)
    }
    
    func sync(booking: Booking) {
        self.booking = booking
        
        fetchUserDogs()
        if booking.hasCoupon {
            fetchCoupon()
        }
    }
}
