//
//  CreateDogData.swift
//  pochi
//
//  Created by akiho on 2016/12/20.
//  Copyright © 2016年 akiho. All rights reserved.
//

import Foundation
import RxSwift

struct CreateDogData: FormData {
    
    private enum Castrated: String, EnumEnumerable {
        case yes = "はい"
        case no = "いいえ"
    }

    init() {
        
    }
    
    let name = InputCellData(
        label: "名前",
        value: "",
        type: InputCellData.InputType.TextField,
        selectItems: nil)
    
    private(set) var breed = InputCellData(
        label: "犬種",
        value: "",
        type: InputCellData.InputType.PickerTextField,
        selectItems: [""])
    
    private(set) var gender = InputCellData(
        label: "性別",
        value: "",
        type: InputCellData.InputType.PickerTextField,
        selectItems: [""])
    
    let birthdate = InputCellData(
        label: "生年月日",
        value: "",
        type: InputCellData.InputType.DatePickerTextField,
        selectItems: nil)
    
    private(set) var size = InputCellData(
        label: "サイズ",
        value: "",
        type: InputCellData.InputType.PickerTextField,
        selectItems: [""])
    
    func getProperties() -> [InputCellData] {
        return [name, breed, gender, birthdate, size]
    }
    
    func observeInput() -> Observable<SendData> {
        return Observable.combineLatest(
            name.value.asObservable(),
            breed.value.asObservable(),
            gender.value.asObservable(),
            birthdate.value.asObservable(),
            size.value.asObservable(),
            resultSelector: { name, breed, gender, birthdate, size -> SendData in
                let breedValue = PublicAssetRepository.shared.dogBreedTypes.filter({ $0.label == breed }).first?.value ?? ""
                let genderValue = PublicAssetRepository.shared.dogGenderTypes.filter({ $0.label == gender }).first?.value ?? ""
                let sizeValue = PublicAssetRepository.shared.dogSizeTypes.filter({ $0.label == size }).first?.value ?? ""
                
                return SendData(name: name, breed: breedValue, gender: genderValue, birthdate: birthdate, size: sizeValue)
            })
    }
    
    func getSendData() -> SendData {
        let breedValue = PublicAssetRepository.shared.dogBreedTypes.filter({ $0.label == breed.value.value }).first?.value ?? ""
        let genderValue = PublicAssetRepository.shared.dogGenderTypes.filter({ $0.label == gender.value.value }).first?.value ?? ""
        let sizeValue = PublicAssetRepository.shared.dogSizeTypes.filter({ $0.label == size.value.value }).first?.value ?? ""
        
        return SendData(name: name.value.value,
                        breed: breedValue,
                        gender: genderValue,
                        birthdate: birthdate.value.value,
                        size: sizeValue)
    }
    
    func setupSelectItems() {
        self.breed.selectItems = PublicAssetRepository.shared.dogBreedTypes.map { $0.label }
        self.gender.selectItems = PublicAssetRepository.shared.dogGenderTypes.map { $0.label }
        self.size.selectItems = PublicAssetRepository.shared.dogSizeTypes.map { $0.label }
    }
    
    struct SendData {
        let name: String
        let breed: String
        let gender: String
        let birthdate: String
        let size: String
        
        func isAllInputFilled() -> Bool {
            return !name.isEmpty && !breed.isEmpty && !gender.isEmpty && !birthdate.isEmpty && !size.isEmpty
        }
    }
}
