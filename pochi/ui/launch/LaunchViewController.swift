//
//  LaunchViewController.swift
//  pochi
//
//  Created by akiho on 2016/12/20.
//  Copyright © 2016年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseRemoteConfig

class LaunchViewController: UIViewController {
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    private let viewModel: LaunchViewModel = LaunchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let remoteConfig = RemoteConfig.remoteConfig()
        
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings!
        
        let expirationDuration = remoteConfig.configSettings.isDeveloperModeEnabled ? 0 : 3600
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration), completionHandler: { status, error -> Void in
            if status == .success {
                remoteConfig.activateFetched()
            }
            
            AppConfig.setRemoteConfig(config: remoteConfig)
            
            self.viewModel.setupPublicAsset()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { _ in
                    if (AppUserStore.shared.restore() != nil) {
                        RootViewController.instantiateForRoot()
                    } else {
                        let to = WelcomeViewController.instantiate()
                        self.present(to as UIViewController, animated: true, completion: nil)
                    }
                }, onError: { e in
                    // TODO: エラーハンドリング
                })
                .addDisposableTo(self.disposeBag)
        })
    }
}
