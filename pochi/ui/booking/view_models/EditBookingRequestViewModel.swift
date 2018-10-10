//
//  EditBookingRequestViewModel.swift
//  pochi
//
//  Created by akiho on 2017/10/21.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EditBookingRequestViewModel {
    
    let appUser: AppUser = AppUserStore.shared.restore()!
    
    private var sendFormData: EditBookingRequestData.SendData?
    private let disposeBag: DisposeBag = DisposeBag()
    private var userDogs: Variable<[Dog]> = Variable<[Dog]>([])
    private(set) var isShowRegisterDogPromotion: Bool = false
    private(set) var isRequesting: Bool = false
    private(set) var booking: Booking
    private var availablePoint: Variable<Int64?> = Variable(nil)
    
    var isSitter: Bool {
        return booking.sitter.id == appUser.overview.id
    }
    
    var observeAvailablePoint: Driver<Int64> {
        return availablePoint.asDriver().filter({ $0 != nil }).map({ $0! })
    }
    
    var justAvailablePoint: Int64? {
        return self.availablePoint.value
    }
    
    var observeUserDogs: Driver<[Dog]> {
        return self.userDogs.asDriver()
    }
    
    init(booking: Booking) {
        self.booking = booking
        
        fetchUserDogs()
        fetchAvailablePoint()
    }
    
    func bind(data: EditBookingRequestData.SendData) {
        self.sendFormData = data
    }
    
    func reloadDogs() {
        isShowRegisterDogPromotion = true
        fetchUserDogs()
    }
    
    func checkCoupon() -> Observable<Bool> {
        self.isRequesting = true
        if let code = sendFormData?.coupon {
            return CouponRepository.shared.fetch(code: code)
                .do(onNext: { _ in
                    self.isRequesting = false
                }, onError: { e in
                    self.isRequesting = false
                })
                .map({ _ in return true })
                .catchErrorJustReturn(false)
        } else {
            return Observable.just(true)
                .do(onNext: { _ in
                    self.isRequesting = false
                })
        }
    }
    
    func checkBooking() -> Observable<Booking> {
        self.isRequesting = true
        return BookingRepository.shared.check(booking: booking, data: sendFormData!)
            .do(onNext: { booking in
                self.isRequesting = false
                self.booking = booking
            }, onError: { e in
                self.isRequesting = false
            })
    }
    
    private func fetchUserDogs() {
        DogRepository.shared.fetchAll(user: booking.user)
            .subscribe(onNext: { dogs in
                self.userDogs.value = dogs
            }, onError: { e in
                
            })
            .addDisposableTo(disposeBag)
    }
    
    private func fetchAvailablePoint() {
        AppUserRepository.shared.me()
            .subscribe(onNext: { appUser in
                self.availablePoint.value = appUser.point
            }, onError: { e in
                
            })
            .addDisposableTo(disposeBag)
    }
}
