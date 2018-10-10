//
//  AppConfig.swift
//  pochi
//
//  Created by akiho on 2017/09/22.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

class AppConfig {
    
    private static var remoteConfig: RemoteConfig?
    
    private init() {
        
    }
    
    static func setRemoteConfig(config: RemoteConfig) {
        self.remoteConfig = config
    }
    
    static let serviceTermsURL: URL = URL(string: "http://www.wanpaku.dog/rules")!
    static let privacyPolicyURL: URL = URL(string: "http://www.wanpaku.dog/policy")!
    static let helpURL: URL = URL(string: "http://www.wanpaku.dog/qa")!
    static let supportURL: URL = URL(string: "http://www.wanpaku.dog/safe")!
    static let reportURL: URL = URL(string: "http://www.wanpaku.dog/fuguai")!
    static let tokusyoURL: URL = URL(string: "http://www.wanpaku.dog/tokusyo")!
    
    static var version: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    static var apiEndpoint: String {
        #if DEBUG
            return "https://pochi-dev-01.appspot.com"
        #else
            return "https://wanpaku-production.appspot.com"
        #endif
    }

    static let bankEndpoint: String = "https://bank.teraren.com"
    
    static var firebasePlistName: String {
        #if DEBUG
            return "GoogleService-Info-Debug"
        #else
            return "GoogleService-Info"
        #endif
    }
}
