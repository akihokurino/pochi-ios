//
//  Section.swift
//  pochi
//
//  Created by akiho on 2017/01/05.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation

class Section {
    private let title: String
    private let sectionHeight: Int
    private let items: [Item]
    
    init(title: String, sectionHeight: Int, items: [Item]) {
        self.title = title
        self.sectionHeight = sectionHeight
        self.items = items
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getItems() -> [Item] {
        return self.items
    }
    
    func getSectionHeight() -> Int {
        return self.sectionHeight
    }
}
