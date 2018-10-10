//
//  SelectBankAccountViewController.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectBankAccountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: SelectBankAccountDataSource!
    private let viewModel: SelectBankAccountViewModel = SelectBankAccountViewModel()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private var dialogDelegate: DialogDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupDialogDelegate()
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupDialogDelegate() {
        self.dialogDelegate = DialogDelegate(container: self)
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
    }
    
    private func setupTableView() {
        dataSource = SelectBankAccountDataSource(tableView: tableView)
        let emptyView = EmptyView.instance()
        emptyView.bind(data: EmptyView.DisplayData(message: "登録している銀行口座がありません"))
        tableView.backgroundView = emptyView
        tableView.backgroundView?.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func observeTableView() {
        viewModel.observeAccounts.asObservable()
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        viewModel.observeEvent
            .drive(onNext: { event in
                switch event {
                case .none:
                    break
                case .refreshed:
                    self.refreshControl.endRefreshing()
                case .empty:
                    self.tableView.backgroundView?.isHidden = false
                }
            })
            .addDisposableTo(disposeBag)
        
        tableView.rx.modelSelected(BankAccount.self).asDriver()
            .filter({ account -> Bool in
                if !account.isActive {
                    self.dialogDelegate.simpleAlert(title: "口座がアクティベートされていません")
                }
                return account.isActive
            })
            .drive(onNext: { account in
                let viewControllers: [UIViewController] = self.navigationController?.viewControllers ?? []
                let from = viewControllers[viewControllers.count - 2]
                (from as? ReturnPointViewController)?.bind(account: account)
                self.navigationController?.popViewController(animated: true)
            })
            .addDisposableTo(disposeBag)
        
    }
    
    func refresh() {
        tableView.backgroundView?.isHidden = true
        viewModel.refresh()
    }
}
