//
//  NoticeListViewController.swift
//  pochi
//
//  Created by akiho on 2017/02/08.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NoticeListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: NoticeListDataSource!
    private let viewModel: NoticeListViewModel = NoticeListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        setupTableView()
        observeTableView()
        
        viewModel.fetchAll()
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
        dataSource = NoticeListDataSource(tableView: tableView)
    }
    
    private func observeTableView() {
        tableView.rx.modelSelected(Notice.self).asDriver().drive(onNext: { notice in
            self.performSegue(withIdentifier: R.segue.noticeListViewController.fromNoticeListToDetail, sender: nil)
        })
        .addDisposableTo(disposeBag)
        
        viewModel.observeNotices.asObservable()
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }
}
