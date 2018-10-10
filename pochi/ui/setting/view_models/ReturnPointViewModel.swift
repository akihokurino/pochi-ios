//
//  ReturnPointViewModel.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ReturnPointViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    private var bankAccount: Variable<BankAccount?> = Variable(nil)
    private var availablePoint: Variable<Int64?> = Variable(nil)
    private var point: Int64 = 0
    private(set) var isRequesting: Bool = false
    
    var observeAvailablePoint: Driver<Int64?> {
        return availablePoint.asDriver()
    }
    
    var observeBankAccount: Driver<BankAccount?> {
        return bankAccount.asDriver()
    }
    
    var justAvailablePoint: Int64 {
        return self.availablePoint.value ?? 0
    }
    
    var isValid: Bool {
        return point >= 10000 && point <= justAvailablePoint && bankAccount.value != nil
    }
    
    func sync(account: BankAccount) {
        self.bankAccount.value = account
    }
    
    func sync(point: Int64) {
        self.point = point
    }
    
    func transfer() -> Observable<Void> {
        isRequesting = true
        return BankAccountRepository.shared.transfer(point: point, account: bankAccount.value!)
            .do(onNext: {
                self.isRequesting = false
                self.updateAvailablePoint()
            }, onError: { e in
                self.isRequesting = false
            })
    }
    
    func updateAvailablePoint() {
        AppUserRepository.shared.me()
            .subscribe(onNext: { appUser in
                self.availablePoint.value = appUser.point
            }, onError: { e in
                
            })
            .addDisposableTo(disposeBag)
    }
}
