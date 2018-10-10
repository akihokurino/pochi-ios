//
//  NoticeListViewModel.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NoticeListViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    private var notices: Variable<[NoticeWithSection]> = Variable<[NoticeWithSection]>([])
    
    var observeNotices: Driver<[NoticeWithSection]> {
        return notices.asDriver()
    }
    
    func fetchAll() {
        NoticeRepository.shared.fetchAll()
            .subscribe(onNext: { items in
                self.notices.value.append(contentsOf: items)
            }, onError: { e in
                
            })
            .addDisposableTo(disposeBag)
    }
}


