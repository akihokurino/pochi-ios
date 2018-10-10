//
//  ProvideTokenProtocol.swift
//  pochi
//
//  Created by akiho on 2017/08/10.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import Moya

protocol ProvideTokenProtocol {
    var authPlugin: AccessTokenPlugin { get }
}

extension ProvideTokenProtocol {
    var authPlugin: AccessTokenPlugin {
        return AccessTokenPlugin(token: TokenStore.shared.fireToken)
    }
}
