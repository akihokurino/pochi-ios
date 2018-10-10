//
//  ReviewTaskData.swift
//  pochi
//
//  Created by akiho on 2017/08/27.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation

struct ReviewTaskData {
    let score: Int
    let content: String
    
    var isValid: Bool {
        return score > 0 && !content.isEmpty
    }
}
