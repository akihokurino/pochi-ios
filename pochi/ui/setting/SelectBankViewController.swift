//
//  SelectBankViewController.swift
//  pochi
//
//  Created by akiho on 2017/06/06.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectBankViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: SelectBankDataSource!
    private var viewModel: SelectBankViewModel = SelectBankViewModel()
    
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
        dataSource = SelectBankDataSource(tableView: tableView)
    }
    
    private func observeTableView() {
        tableView.rx.modelSelected(Bank.self)
            .asDriver()
            .do(onNext: { bank in
                self.viewModel.selectedBank = bank
            })
            .drive(onNext: { _ in
                self.performSegue(withIdentifier: R.segue.selectBankViewController.fromSelectBankToRegisterBankAccount.identifier,
                                  sender: nil)
            })
            .addDisposableTo(disposeBag)
        
        viewModel.observeBanks.asObservable()
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.selectBankViewController.fromSelectBankToRegisterBankAccount.identifier && viewModel.selectedBank != nil {
            let to = segue.destination as! RegisterBankAccountViewController
            to.bind(bank: viewModel.selectedBank!)
        }
    }
}
