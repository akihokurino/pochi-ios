//
//  DogProfileViewModel.swift
//  pochi
//
//  Created by akiho on 2017/07/12.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DogProfileViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    private var dogs: Variable<[DogWithSection]> = Variable<[DogWithSection]>([])
    private let user: User
    
    var selectedDog: Dog? = nil
    
    var observeDogs: Driver<[DogWithSection]> {
        return dogs.asDriver()
    }
    
    init(user: User) {
        self.user = user
    }
    
    func fetchDogs() {
        DogRepository.shared.fetchAll(user: user.overview)
            .subscribe(onNext: { dogs in
                self.dogs.value = dogs.map({
                    return DogWithSection(header: "1匹目のプロフィール", items: [$0])
                })
            })
            .addDisposableTo(disposeBag)
    }
}
