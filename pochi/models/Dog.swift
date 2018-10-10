//
//  Pet.swift
//
//
//  Created by akiho on 2016/12/18.
//
//

import Foundation
import RxSwift
import RxDataSources

class Dog {
    let id: Int64
    let name: String
    let breed: String
    let gender: String
    let age: Int
    let birthdate: String
    let size: String
    let isCastrated: Bool
    let createdAt: Int64
    let updatedAt: Int64
    let userId: String
    let iconUrl: String
    
    init(id: Int64,
         name: String,
         breed: String,
         gender: String,
         age: Int,
         birthdate: String,
         size: String,
         isCastrated: Bool,
         createdAt: Int64,
         updatedAt: Int64,
         userId: String,
         iconUrl: String) {
        self.id = id
        self.name = name
        self.breed = breed
        self.gender = gender
        self.age = age
        self.birthdate = birthdate
        self.size = size
        self.isCastrated = isCastrated
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.userId = userId
        self.iconUrl = iconUrl
    }
}

struct DogWithSection {
    var header: String
    var items: [Item]
}

extension DogWithSection: SectionModelType {
    typealias Item = Dog
    
    init(original: DogWithSection, items: [Item]) {
        self = original
        self.items = items
    }
}


