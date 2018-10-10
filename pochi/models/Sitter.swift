//
//  Sitter.swift
//  pochi
//
//  Created by akiho on 2017/07/01.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

class Sitter: User {
    enum DogSizeType: String {
        case large = "LARGE"
        case medium = "MEDIUM"
        case small = "SMALL"
    }
    
    enum DogAttribute: String {
        case castratedMale = "CASTRATED_MALE"
        case castratedFemale = "CASTRATED_FEMALE"
        case unCastratedMale = "UN_CASTRATED_MALE"
        case unCastratedFemale = "UN_CASTRATED_FEMALE"
        case hasChewingHabit = "HAS_CHEWING_HABIT"
        case hasBarkHabit = "HAS_BARK_HABIT"
        case underOneYearOld = "UNDER_ONE_YEAR_OLD"
        case overTenYearsOld = "OVER_TEN_YEARS_OLD"
        case pottyIndoor = "POTTY_INDOOR"
        case pottyOutdoor = "POTTY_OUTDOOR"
        case indoor = "INDOOR"
        case outdoor = "OUTDOOR"
    }
    
    enum Option: String {
        case earlyMorning = "EARLY_MORNING"
        case lateNight = "LATE_NIGHT"
    }
    
    enum HouseType: String {
        case isolated = "ISOLATED"
        case apartment = "APARTMENT"
    }
    
    enum SmokingPolicy: String {
        case smoking = "SMOKING"
        case nonSmoking = "NON_SMOKING"
    }
    
    enum KidsType: String {
        case infant = "INFANT"
        case schoolchild = "SCHOOLCHILD"
    }
    
    enum DogKeepingStyle: String {
        case indoorCage = "INDOOR_CAGE"
        case indoorLoose = "INDOOR_LOOSE"
        case outdoorCage = "OUTDOOR_CAGE"
        case outdoorLoose = "OUTDOOR_LOOSE"
    }
    
    enum WalkingPolicy: String {
        case none = "NONE"
        case onceADay = "ONCE_A_DAY"
        case twiceADay = "TWICE_A_DAY"
        case threeTimesADay = "THREE_TIMES_A_DAY"
    }
    
    let activated: Bool
    let acceptableDogSizes: [DogSizeType]
    let houseType: HouseType
    let smokingPolicy: SmokingPolicy
    let kidsTypes: [KidsType]
    let serviceDescription: String
    let dogKeepingStyle: DogKeepingStyle
    let walkingPolicy: WalkingPolicy
    let acceptableDogTypes: [DogAttribute]
    let unacceptableDogTypes: [DogAttribute]
    let options: [Option]
    let geoHexCode: String
    let address: Address?
    let mainImage: String
    let interiorImages: [Image]
    
    init(activated: Bool,
         introductionMessage: String,
         rawAcceptableDogSizes: [String],
         rawHouseType: String,
         rawSmokingPolicy: String,
         rawKidsTypes: [String],
         serviceDescription: String,
         rawDogKeepingStyle: String,
         rawWalkingPolicy: String,
         rawAcceptableDogTypes: [String],
         rawUnacceptableDogTypes: [String],
         rawOptions: [String],
         geoHexCode: String,
         createdAt: Int64,
         updatedAt: Int64,
         scoreAverage: Double,
         id: String,
         firstName: String,
         lastName: String,
         nickname: String,
         iconUri: String,
         address: Address?,
         mainImage: String,
         interiorImages: [Image],
         point: Int64) {
        self.activated = activated
        self.acceptableDogSizes = rawAcceptableDogSizes.map({ DogSizeType(rawValue: $0)! })
        self.houseType = HouseType(rawValue: rawHouseType)!
        self.smokingPolicy = SmokingPolicy(rawValue: rawSmokingPolicy)!
        self.kidsTypes = rawKidsTypes.map({ KidsType(rawValue: $0)! })
        self.serviceDescription = serviceDescription
        self.dogKeepingStyle = DogKeepingStyle(rawValue: rawDogKeepingStyle)!
        self.walkingPolicy = WalkingPolicy(rawValue: rawWalkingPolicy)!
        self.acceptableDogTypes = rawAcceptableDogTypes.map({ DogAttribute(rawValue: $0)! })
        self.unacceptableDogTypes = rawUnacceptableDogTypes.map({ DogAttribute(rawValue: $0)! })
        self.options = rawOptions.map({ Option(rawValue: $0)! })
        self.geoHexCode = geoHexCode
        self.address = address
        self.mainImage = mainImage
        self.interiorImages = interiorImages
        
        super.init(id: id,
                   firstName: firstName,
                   lastName: lastName,
                   nickname: nickname,
                   iconUri: iconUri,
                   introductionMessage: introductionMessage,
                   createdAt: createdAt,
                   updatedAt: updatedAt,
                   roles: [.host, .user],
                   point: point,
                   scoreAverage: scoreAverage)
    }
}
