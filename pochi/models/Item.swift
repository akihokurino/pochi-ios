//
//  Item.swift
//  pochi
//
//  Created by akiho on 2017/01/06.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit

struct Item {
    
    enum ItemType {
        case None
        case Notice
        case Profile
        case DogProfile
        case HostProfile
        case ReturnPoint
        case Setting
        case Help
        case Support
        case ReportBug
        case ChangeEmail
        case ChangePassword
        case PushNotification
        case ServiceTerms
        case PrivacyPolicy
        case License
        case Version
        case Logout
        case FinishedLeave
        case FinishedKeep
        case EditPaymentInfo
        case SettingBank
    }
    
    let label: String
    let labelColor: UIColor
    let hasArrow: Bool
    let isCenter: Bool
    let type: ItemType
    
    init(label: String, labelColor: UIColor, hasArrow: Bool, isCenter: Bool, type: ItemType) {
        self.label = label
        self.labelColor = labelColor
        self.hasArrow = hasArrow
        self.isCenter = isCenter
        self.type = type
    }
}
