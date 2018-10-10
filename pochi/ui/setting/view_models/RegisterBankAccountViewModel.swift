//
//  RegisterBankAccountViewModel.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RegisterBankAccountViewModel {
    
    private var sendFormData: CreateBankAccountData.SendData!
    private let disposeBag: DisposeBag = DisposeBag()
    
    private(set) var isLoading: Bool = false
    let selectedBank: Bank

    init(bank: Bank) {
        selectedBank = bank
    }
    
    func bind(data: CreateBankAccountData.SendData) {
        self.sendFormData = data
    }
    
    func create() -> Observable<BankAccount> {
        self.isLoading = true
        return BankAccountRepository.shared.create(data: sendFormData, bank: selectedBank)
            .do(onNext: { _ in
                self.isLoading = false
            }, onError: { e in
                self.isLoading = false
            })
    }
}
