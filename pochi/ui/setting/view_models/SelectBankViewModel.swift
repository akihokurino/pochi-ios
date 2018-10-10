//
//  SelectBankViewModel.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SelectBankViewModel {

    private let disposeBag: DisposeBag = DisposeBag()
    private var banks: Variable<[BankWithSection]> = Variable([])
    
    var selectedBank: Bank? = nil
    
    var observeBanks: Driver<[BankWithSection]> {
        return banks.asDriver()
    }
    
    init() {
        fetchAll()
    }
    
    private func fetchAll() {
        BankRepository.shared.fetchAll()
            .subscribe(onNext: { banks in
                self.banks.value = banks
            })
            .addDisposableTo(disposeBag)
    }
}
