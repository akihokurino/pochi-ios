//
//  SettingViewController.swift
//  pochi
//
//  Created by akiho on 2017/01/06.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: SettingDataSource!
    private var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        setupTableView()
        observerTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
    }
    
    private func setupTableView() {
        dataSource = SettingDataSource(tableView: tableView)
        dataSource.bind()
    }
    
    private func observerTableView() {
        dataSource.observeSelectItem
            .drive(onNext: { type in
                switch type {
                case .ChangeEmail:
                    self.performSegue(withIdentifier: R.segue.settingViewController.fromSettingToEditEmail, sender: nil)
                case .ChangePassword:
                    self.performSegue(withIdentifier: R.segue.settingViewController.fromSettingToEditPassword, sender: nil)
                case .PushNotification:
                    self.performSegue(withIdentifier: R.segue.settingViewController.fromSettingToSettingPushNotification, sender: nil)
                case .ServiceTerms:
                    self.toServiceTermsViewController()
                case .PrivacyPolicy:
                    self.toPrivacyPolicyViewController()
                case .License:
                    self.performSegue(withIdentifier: R.segue.settingViewController.fromSettingToLicenseList, sender: nil)
                case .Logout:
                    AppUserRepository.shared.signOut()
                    let launch = R.storyboard.main.instantiateInitialViewController()
                    UIApplication.shared.keyWindow?.rootViewController = launch
                default:
                    break
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    private func toServiceTermsViewController() {
        let to = ModalWebViewController.instantiate(title: "利用規約", url: AppConfig.serviceTermsURL)
        present(to as UIViewController, animated: true, completion: nil)
    }
    
    private func toPrivacyPolicyViewController() {
        let to = ModalWebViewController.instantiate(title: "プライバシーポリシー", url: AppConfig.privacyPolicyURL)
        present(to as UIViewController, animated: true, completion: nil)
    }
}
