//
//  SelectBankAccountViewModel.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SelectBankAccountViewModel {
    
    enum Event {
        case none
        case refreshed
        case empty
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var accounts: Variable<[BankAccount]> = Variable([])
    private var event: Variable<Event> = Variable(.none)
    private var isRefreshing: Bool = false
    
    var observeEvent: Driver<Event> {
        return event.asDriver()
    }
    
    var observeAccounts: Driver<[BankAccount]> {
        return accounts.asDriver()
    }
    
    init() {
        fetchAll()
    }
    
    private func fetchAll() {
        BankAccountRepository.shared.fetchAll()
            .do(onNext: { _ in
                if self.isRefreshing {
                    self.isRefreshing = false
                    self.event.value = .refreshed
                }
            })
            .subscribe(onNext: { accounts in
                self.accounts.value = accounts
            }, onCompleted: {
                if self.accounts.value.isEmpty {
                    self.event.value = .empty
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    func refresh() {
        isRefreshing = true
        fetchAll()
    }
}
