//
//  RegisterBankAccountViewController.swift
//  pochi
//
//  Created by akiho on 2017/09/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class RegisterBankAccountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: RegisterBankAccountDataSource!
    fileprivate var formDelegate: FormDelegate!
    private var footerView: FooterBtnView!
    private var viewModel: RegisterBankAccountViewModel!
    
    func bind(bank: Bank) {
        self.viewModel = RegisterBankAccountViewModel(bank: bank)
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
        dataSource = RegisterBankAccountDataSource(tableView: tableView, delegate: self)
        
        footerView = FooterBtnView.instance()
        footerView.setBtnTitle(title: "登録する")
        tableView.tableFooterView = footerView
    }
    
    private func observeTableView() {
        dataSource.bind(bank: self.viewModel.selectedBank)
        
        footerView.observeBtn.asObservable()
            .filter({ !self.viewModel.isLoading })
            .observeOn(MainScheduler.instance)
            .do(onNext: {
                self.view.endEditing(true)
            })
            .do(onNext: {
                SVProgressHUD.show(withStatus: "登録中...")
            })
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap({ _ -> Observable<Bool> in
                return self.viewModel.create()
                    .map({ _ in true })
                    .catchErrorJustReturn(false)
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result {
                    SVProgressHUD.showSuccess(withStatus: "登録が完了しました")
                    
                    // 2つ戻る
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: false)
                } else {
                    SVProgressHUD.showError(withStatus: "登録に失敗しました")
                }
            })
            .addDisposableTo(disposeBag)
        
        dataSource.observeEvent
            .drive(onNext: { event in
                switch event {
                case .none:
                    break
                case .closeKeyboard:
                    self.view.endEditing(true)
                }
            })
            .addDisposableTo(disposeBag)
        
        dataSource.observeInput
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { data in
                self.viewModel.bind(data: data)
                self.footerView.setBtnState(state: data.isAllInputFilled() ? .active : .inActive)
            })
            .addDisposableTo(disposeBag)
    }
}

extension RegisterBankAccountViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate.setActiveTextInput(field: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        formDelegate.setActiveTextInput(field: nil)
        return true
    }
}

extension RegisterBankAccountViewController: PickerTextFieldDelegate {
    func select(value: String) {
        if !value.isEmpty {
            
        }
    }
}


