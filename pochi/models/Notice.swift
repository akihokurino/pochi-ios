//
//  Notice.swift
//  pochi
//
//  Created by akiho on 2017/04/23.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class Notice {
    
}

struct NoticeWithSection {
    var header: String
    var items: [Item]
}

extension NoticeWithSection: SectionModelType {
    typealias Item = Notice
    
    init(original: NoticeWithSection, items: [Item]) {
        self = original
        self.items = items
    }
}

