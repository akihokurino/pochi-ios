//
//  ClosedLeaveBookingListViewController.swift
//  pochi
//
//  Created by akiho on 2017/06/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ClosedLeaveBookingListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: ClosedLeaveBookingListDataSource!
    private let viewModel: ClosedLeaveBookingListViewModel = ClosedLeaveBookingListViewModel()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
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
        dataSource = ClosedLeaveBookingListDataSource(tableView: tableView)
        let emptyView = EmptyView.instance()
        emptyView.bind(data: EmptyView.DisplayData(message: "終了したお泊りはありません"))
        tableView.backgroundView = emptyView
        tableView.backgroundView?.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.tableFooterView = FooterLoadingView.instance()
    }
    
    func refresh() {
        viewModel.refresh()
    }
    
    private func observeTableView() {
        viewModel.observeBookings.asObservable()
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx.contentOffset.asDriver()
            .drive(onNext: { offset in
                if offset.y + self.tableView.frame.size.height > self.tableView.contentSize.height && self.tableView.isDragging {
                    self.viewModel.fetchBookingsEachPage()
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.observeEvent
            .drive(onNext: { event in
                switch event {
                case .none:
                    break
                case .refreshed:
                    self.refreshControl.endRefreshing()
                    self.tableView.tableFooterView?.isHidden = false
                case .empty:
                    self.tableView.backgroundView?.isHidden = false
                case .completedBookingPagination:
                    self.tableView.tableFooterView?.isHidden = true
                }
            })
            .addDisposableTo(disposeBag)
    }
}
