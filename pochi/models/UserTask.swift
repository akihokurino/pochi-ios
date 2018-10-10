//
//  Task.swift
//  pochi
//
//  Created by akiho on 2017/05/27.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class UserTask {
    
    enum TaskType: String {
        case report = "DAILY_REPORT"
        case review = "REVIEW"
    }
    
    enum Status: String {
        case open = "OPEN"
        case done = "DONE"
        case closed = "CLOSE_BY_SYSTEM"
    }
    
    let id: Int64
    let bookingId: Int64
    let type: TaskType
    let status: Status
    let date: String
    let title: String
    let forReviewTask: ForReviewTask?
    let forReportTask: ForDailyReportTask?
    
    init(id: Int64,
         bookingId: Int64,
         rawType: String,
         rawStatus: String,
         date: String,
         title: String,
         forReviewTask: ForReviewTask?,
         forReportTask: ForDailyReportTask?) {
        self.id = id
        self.bookingId = bookingId
        self.type = TaskType(rawValue: rawType)!
        self.status = Status(rawValue: rawStatus)!
        self.date = date
        self.title = title
        self.forReviewTask = forReviewTask
        self.forReportTask = forReportTask
    }
}

struct ForReviewTask {
    let revieweeId: String
}

struct ForDailyReportTask {
    let dogId: Int64
    let imageUrl: String
    let comment: String
}

struct UserTaskWithSection {
    var header: String
    var items: [Item]
}

extension UserTaskWithSection: SectionModelType {
    typealias Item = UserTask
    
    init(original: UserTaskWithSection, items: [Item]) {
        self = original
        self.items = items
    }
}


