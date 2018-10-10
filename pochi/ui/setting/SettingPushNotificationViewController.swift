//
//  SettingPushNotificationViewController.swift
//  pochi
//
//  Created by akiho on 2017/06/05.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingPushNotificationViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: SettingPushNotificationDataSource!
    private var footerView: FooterBtnView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        observeTableView()
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

    private func setupTableView() {
        dataSource = SettingPushNotificationDataSource(tableView: tableView)
        
        footerView = FooterBtnView.instance()
        footerView.setBtnTitle(title: "変更を保存する")
        tableView.tableFooterView = footerView
        
        dataSource.bind()
    }
    
    private func observeTableView() {
        footerView.observeBtn
            .drive(onNext: {
                
            })
            .addDisposableTo(disposeBag)
    }
}
