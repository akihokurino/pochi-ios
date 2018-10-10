//
//  SettingBankAccountViewController.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingBankAccountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: SettingBankAccountDataSource!
    private var footerView: FooterLinkView!
    private let viewModel: SettingBankAccountViewModel = SettingBankAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
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
        
        self.viewModel.fetchAll()
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
        dataSource = SettingBankAccountDataSource(tableView: tableView)
        
        footerView = FooterLinkView.instance()
        footerView.setup(title: "新しい銀行口座を登録する")
        tableView.tableFooterView = footerView
    }
    
    private func observeTableView() {
        viewModel.observeAccounts.asObservable()
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        footerView.observeLinkbtn
            .drive(onNext: {
                self.performSegue(withIdentifier: R.segue.settingBankAccountViewController.fromSettingBankAccountToSelectBank.identifier,
                                  sender: nil)
            })
            .addDisposableTo(disposeBag)
    }
}
