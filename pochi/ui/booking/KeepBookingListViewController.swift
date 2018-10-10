//
//  KeepBookingListViewController.swift
//  pochi
//
//  Created by akiho on 2017/05/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// ホストとして預かる
class KeepBookingListViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: BookingListDataSource!
    private let viewModel: KeepBookingListViewModel = KeepBookingListViewModel()
    private var emptyView: EmptyView!
    private let refreshControl: UIRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        setupTableView()
        observeSegmentedControl()
        observeTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.tableFooterView?.isHidden = false
        self.tableView.backgroundView?.isHidden = true
        viewModel.fetchAll()
    }
    
    private func observeSegmentedControl() {
        segmentedControl.rx.value
            .asDriver()
            .drive(onNext: { value in
                self.tableView.tableFooterView?.isHidden = false
                self.tableView.backgroundView?.isHidden = true
                self.viewModel.currentSegment = KeepBookingListViewModel.Segment(rawValue: value)!
                self.viewModel.fetchAll()
            })
            .addDisposableTo(disposeBag)
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
    }
    
    private func setupTableView() {
        dataSource = BookingListDataSource(tableView: tableView)
        let emptyView = EmptyView.instance()
        emptyView.bind(data: EmptyView.DisplayData(message: "メッセージはありません"))
        tableView.backgroundView = emptyView
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.tableFooterView = FooterLoadingView.instance()
    }
    
    func refresh() {
        viewModel.refresh()
    }
    
    private func observeTableView() {
        tableView.rx.modelSelected(Booking.self)
            .asDriver()
            .drive(onNext: { item in
                self.toMessageViewController(booking: item)
            })
            .addDisposableTo(disposeBag)
        
        viewModel.observeBookings.asObservable()
            .bindTo(tableView.rx.items(dataSource: dataSource))
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
    
    fileprivate func toMessageViewController(booking: Booking) {
        let to = MessageNavigationViewController.instantiate(booking: booking)
        present(to as UIViewController, animated: true, completion: nil)
    }
}
