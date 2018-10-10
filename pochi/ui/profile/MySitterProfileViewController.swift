//
//  MySitterProfileViewController.swift
//  pochi
//
//  Created by akiho on 2017/02/01.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MySitterProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var closeBtn: UIBarButtonItem!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: MySitterProfileDataSource!
    private let viewModel: MySitterProfileViewModel = MySitterProfileViewModel(id: AppUserStore.shared.restore()!.overview.id)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        setupTableView()
        observeEditBtn()
        observeCloseBtn()
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
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
        
        // TODO: ファーストリリースではホストの編集はできない
        self.editBtn.isEnabled = false
        self.editBtn.tintColor = UIColor.clear
    }
    
    private func setupTableView() {
        dataSource = MySitterProfileDataSource(tableView: tableView)
    }
    
    private func observeTableView() {
        dataSource.bind(sitter: viewModel.observeSitter)
    }
    
    private func observeEditBtn() {
        editBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                self.performSegue(withIdentifier: R.segue.mySitterProfileViewController.fromSitterProfileToEdit, sender: nil)
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
