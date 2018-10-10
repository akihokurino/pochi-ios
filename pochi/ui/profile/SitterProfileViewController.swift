//
//  SitterProfileViewController.swift
//  pochi
//
//  Created by akiho on 2017/01/27.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SitterProfileViewController: UIViewController {
    
    static func instantiate(sitter: Sitter) -> SitterProfileViewController {
        let vc = R.storyboard.profile.sitterProfileViewController()!
        vc.viewModel = SitterProfileViewModel(sitter: sitter)
        return vc
    }

    @IBOutlet weak var closeBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: SitterProfileDataSource!
    private var viewModel: SitterProfileViewModel!
    private var tableHeaderView: ProfileHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavigation()
        setupTableView()
        observeTableView()
        observeCloseBtn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.tintColor = UIColor.white
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        navigationItem.backBarButtonItem = backBtn
    }
    
    private func setupTableView() {
        dataSource = SitterProfileDataSource(tableView: tableView, sitter: viewModel.sitter)
        
        tableHeaderView = ProfileHeaderView.instance()
        tableView.tableHeaderView = tableHeaderView
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    private func observeTableView() {
        dataSource.bind(reviews: viewModel.observeReviews)
        dataSource.bind(state: viewModel.observeStateReviewPagination)
        dataSource.bind(dogs: viewModel.observeUserDogs)
        dataSource.bind(reviewTotalCount: viewModel.observeReviewTotalCount)
        
        dataSource.observeAction
            .drive(onNext: { action in
                switch action {
                case .none:
                    break
                case .reviewMore:
                    self.viewModel.fetchReviewsEachPage()
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeCloseBtn() {
        closeBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }
}
