//
//  EditDogProfileViewModel.swift
//  pochi
//
//  Created by akiho on 2017/08/16.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class EditDogProfileViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    private var sendFormData: EditDogData.SendData!
    private var sendImageData: UIImage?
    
    private(set) var dog: Dog
    private(set) var isLoading: Bool = false
    
    init(dog: Dog) {
        self.dog = dog
    }
    
    func bind(data: EditDogData.SendData) {
        self.sendFormData = data
    }
    
    func bind(image: UIImage) {
        self.sendImageData = image
    }
    
    func update() -> Observable<Dog> {
        isLoading = true
        
        return DogRepository.shared.update(dog: dog, data: sendFormData)
            .flatMap({ dog -> Observable<Dog> in
                if let imageData = self.sendImageData {
                    return DogRepository.shared.updateIcon(dog: dog, image: imageData)
                } else {
                    return Observable.just(dog)
                }
            })
            .do(onNext: { dog in
                self.dog = dog
                self.isLoading = false
            }, onError: { e in
                self.isLoading = false
            })
    }
}
