//
//  CreateMessageData.swift
//  pochi
//
//  Created by akiho on 2017/07/03.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation

struct CreateMessageData {
    let content: String
    
    var isValid: Bool {
        return !content.isEmpty
    }
}
