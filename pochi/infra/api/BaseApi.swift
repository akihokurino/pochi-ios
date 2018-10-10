//
//  BaseApi.swift
//  pochi
//
//  Created by akiho on 2017/03/22.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation

protocol BaseApi {
    
}

extension BaseApi {
    var baseUrl: String {
        return AppConfig.apiEndpoint
    }  
}
