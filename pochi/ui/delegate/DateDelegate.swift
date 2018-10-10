//
//  DateDelegate.swift
//  pochi
//
//  Created by akiho on 2017/07/18.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation

class DateDelegate {
    
    private init() {
        
    }
    
    static func timestampToDateString(timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from: date)
    }
    
    static func dateToDateString(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format.string(from: date)
    }
    
    static func dateToTimestamp(date: Date) -> Int64 {
        return Int64((date.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    static func int64ToDate(timestamp: Int64) -> Date {
        return Date(timeIntervalSince1970: Double(timestamp))
    }
    
    static func stringToDate(dateString: String) -> Date? {
        let date_formatter: DateFormatter = DateFormatter()
        date_formatter.locale = NSLocale(localeIdentifier: "ja") as Locale!
        date_formatter.dateFormat = "yyyy/MM/dd"
        return date_formatter.date(from: dateString)
    }
}
