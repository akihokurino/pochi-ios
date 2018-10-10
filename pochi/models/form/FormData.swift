//
//  FormData.swift
//  pochi
//
//  Created by akiho on 2017/03/26.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

protocol FormData {
    associatedtype T
    
    func getProperties() -> [InputCellData]
    
    func observeInput() -> Observable<T>
}
