//
//  ReportTaskData.swift
//  pochi
//
//  Created by akiho on 2017/08/27.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation

struct ReportTaskData {
    let image: UIImage?
    let content: String
    
    var isValid: Bool {
        return image != nil && !content.isEmpty
    }
}
