//
//  NoticeDetailViewController.swift
//  pochi
//
//  Created by akiho on 2017/02/08.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NoticeDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: NoticeDetailDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        setupTableView()
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
        dataSource = NoticeDetailDataSource(tableView: tableView)
        dataSource.bind()
    }
}
