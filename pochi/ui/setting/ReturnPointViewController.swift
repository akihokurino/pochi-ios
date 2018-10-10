//
//  ReturnPointViewController.swift
//  pochi
//
//  Created by akiho on 2017/06/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class ReturnPointViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: ReturnPointDataSource!
    fileprivate var footerView: FooterBtnView!
    private var tableDelegate: ReturnPointTableDelegate!
    fileprivate var formDelegate: FormDelegate!
    fileprivate let viewModel: ReturnPointViewModel = ReturnPointViewModel()
    private var headerView: UIView!
    
    func bind(account: BankAccount) {
        viewModel.sync(account: account)
        footerView.setBtnState(state: viewModel.isValid ? .active : .inActive)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupInput()
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
        formDelegate.setup()
        
        viewModel.updateAvailablePoint()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        formDelegate.reset()
    }
    
    private func setupInput() {
        formDelegate = FormDelegate(scrollView: tableView)
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
    }
    
    private func setupTableView() {
        tableDelegate = ReturnPointTableDelegate(tableView: tableView)
        dataSource = ReturnPointDataSource(tableView: tableView, delegate: self, container: self)
        
        tableView.tableHeaderView = tableDelegate.generateHeaderView(point: 0)
        
        footerView = FooterBtnView.instance()
        footerView.setBtnTitle(title: "申請する")
        tableView.tableFooterView = footerView
        
        dataSource.bind()
    }
    
    private func observeTableView() {
        footerView.observeBtn.asObservable()
            .filter({ !self.viewModel.isRequesting })
            .observeOn(MainScheduler.instance)
            .do(onNext: {
                self.view.endEditing(true)
            })
            .do(onNext: {
                SVProgressHUD.show(withStatus: "払い戻し中...")
            })
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap({ _ -> Observable<Bool> in
                return self.viewModel.transfer()
                    .map({ _ in true })
                    .catchErrorJustReturn(false)
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result {
                    SVProgressHUD.showSuccess(withStatus: "払い戻しが完了しました")
                } else {
                    SVProgressHUD.showError(withStatus: "払い戻しに失敗しました")
                }
            })
            .addDisposableTo(disposeBag)

        dataSource.observeAction
            .drive(onNext: { action in
                switch action {
                case .none:
                    break
                case .selectBankAccount:
                    self.performSegue(withIdentifier: R.segue.returnPointViewController.fromReturnPointToSelectBankAccount, sender: nil)
                }
            })
            .addDisposableTo(disposeBag)
        
        footerView.observeBtn
            .drive(onNext: {
                
            })
            .addDisposableTo(disposeBag)
        
        dataSource.bind(account: viewModel.observeBankAccount)
        
        dataSource.observePoint
            .drive(onNext: { point in
                self.viewModel.sync(point: point)
                self.footerView.setBtnState(state: self.viewModel.isValid ? .active : .inActive)
            })
            .addDisposableTo(disposeBag)
        
        viewModel.observeAvailablePoint
            .drive(onNext: { point in
                self.tableView.tableHeaderView = self.tableDelegate.generateHeaderView(point: point ?? 0)
            })
            .addDisposableTo(disposeBag)
    }
}

extension ReturnPointViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate.setActiveTextInput(field: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        formDelegate.setActiveTextInput(field: nil)
        return true
    }
}
