//
//  MySitterProfileViewModel.swift
//  pochi
//
//  Created by akiho on 2017/08/09.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MySitterProfileViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    private var sitter: Variable<Sitter?> = Variable(nil)
    
    var observeSitter: Driver<Sitter?> {
        return sitter.asDriver()
    }
    
    init(id: String) {
        SitterRepository.shared.fetch(id: id)
            .subscribe(onNext: { sitter in
                self.sitter.value = sitter
            }, onError: { e in
                
            })
            .addDisposableTo(disposeBag)
    }
}
