//
//  SessionService.swift
//  pochi
//
//  Created by Akiho on 2016/12/04.
//  Copyright © 2016年 akiho. All rights reserved.
//

import Foundation

protocol AppUserStoreProtocol {
    var provider: AppUserStore.Provider? { get }
    func store(user: AppUser)
    func store(provider: AppUserStore.Provider)
    func restore() -> AppUser?
    func clear()
}

class AppUserStore: AppUserStoreProtocol {
    
    enum Provider: String {
        case email = "email"
        case facebook = "facebook"
    }
    
    struct UserDefaultsKey {
        static let USER = "user"
        static let PROVIDER = "provider"
    }
    
    static let shared: AppUserStoreProtocol = AppUserStore()
    private let userDefaults = UserDefaults.standard
    
    var provider: Provider? {
        if let value = self.userDefaults.string(forKey: UserDefaultsKey.PROVIDER) {
            return Provider(rawValue: value)
        } else {
            return nil
        }
    }
    
    private init() {
        
    }
    
    func store(user: AppUser) {
        let archived = NSKeyedArchiver.archivedData(withRootObject: AppUserStoreData.from(user: user))
        self.userDefaults.set(archived, forKey: UserDefaultsKey.USER)
        self.userDefaults.synchronize()
    }
    
    func restore() -> AppUser? {
        guard
            let unarchived = self.userDefaults.object(forKey: UserDefaultsKey.USER) as? NSData,
            let user = NSKeyedUnarchiver.unarchiveObject(with: unarchived as Data) as? AppUserStoreData else {
                return nil
        }
        
        return user.to()
    }
    
    func store(provider: AppUserStore.Provider) {
        self.userDefaults.set(provider.rawValue, forKey: UserDefaultsKey.PROVIDER)
        self.userDefaults.synchronize()
    }
    
    func clear() {
        self.userDefaults.removeObject(forKey: UserDefaultsKey.USER)
    }
}

