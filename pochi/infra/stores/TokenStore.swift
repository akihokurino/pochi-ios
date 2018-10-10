//
//  TokenStore.swift
//  pochi
//
//  Created by akiho on 2017/05/09.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation

protocol TokenStoreProtocol {
    var fireToken: String { get }
    func storeFireToken(token: String)
    func clear()
}

class TokenStore: TokenStoreProtocol {
    struct UserDefaultsKey {
        static let KEY_FIRE_TOKEN: String = "key_fire_token"
    }
    
    static let shared: TokenStoreProtocol = TokenStore()
    private let userDefaults = UserDefaults.standard
    
    var fireToken: String {
        return self.userDefaults.string(forKey: UserDefaultsKey.KEY_FIRE_TOKEN) ?? ""
    }
    
    private init() {
        
    }
    
    func storeFireToken(token: String) {
        self.userDefaults.set(token, forKey: UserDefaultsKey.KEY_FIRE_TOKEN)
        self.userDefaults.synchronize()
    }
    
    func clear() {
        self.userDefaults.removeObject(forKey: UserDefaultsKey.KEY_FIRE_TOKEN)
    }
}


