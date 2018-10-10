//
//  NoticeRepository.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import Moya

class NoticeRepository: ProvideTokenProtocol {
    static let shared = NoticeRepository()
    
    private var provider: RxMoyaProvider<NoticeApi> {
        return RxMoyaProvider<NoticeApi>(plugins: [authPlugin])
    }
    
    private init() {
        
    }
    
    func fetchAll() -> Observable<[NoticeWithSection]> {
        var data: [Notice] = []
        for _ in 0...20 {
            data.append(Notice())
        }
        let items = Observable.just([
            NoticeWithSection(header: "2017年11月10日", items: data),
            NoticeWithSection(header: "2017年11月10日", items: data)
            ])
        
        return items
    }
}
