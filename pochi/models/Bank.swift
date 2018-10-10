//
//  Bank.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class Bank {
    let code: String
    let kana: String
    let name: String
    
    init(code: String, kana: String, name: String) {
        self.code = code
        self.kana = kana
        self.name = name
    }
    
    static var jisOrder: [String] {
        let string: String = "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホマミムメモヤユヨラリルレロワ"
        return string.characters.map({ String($0) })
    }
    
    struct Branch {
        let code: String
        let kana: String
        let name: String
        
        init(code: String, kana: String, name: String) {
            self.code = code
            self.kana = kana
            self.name = name
        }
    }
}

struct BankWithSection {
    var header: String
    var items: [Item]
}

extension BankWithSection: SectionModelType {
    typealias Item = Bank
    
    init(original: BankWithSection, items: [Item]) {
        self = original
        self.items = items
    }
}
