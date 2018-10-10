//
//  UserProfileViewController.swift
//  pochi
//
//  Created by akiho on 2017/01/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var closeBtn: UIBarButtonItem!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: UserProfileDataSource!
    private var viewModel: UserProfileViewModel!
    private var tableHeaderView: ProfileHeaderView!
    
    func bind(user: User) {
        self.viewModel = UserProfileViewModel(user: user)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        setupTableView()
        observeTableView()
        observeEditBtn()
        observeCloseBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataSource.bind(user: self.viewModel.user)
        tableHeaderView.bind(user: self.viewModel.user)
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.tintColor = UIColor.white
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        navigationItem.backBarButtonItem = backBtn
        
        if !viewModel.user.isAppUser {
            editBtn.isEnabled = false
            editBtn.tintColor = UIColor.clear
        }
    }
    
    private func setupTableView() {
        dataSource = UserProfileDataSource(tableView: tableView, user: viewModel.user)
        
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
    
    private func observeEditBtn() {
        editBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                self.performSegue(withIdentifier: R.segue.userProfileViewController.fromUserProfileToEdit, sender: nil)
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
