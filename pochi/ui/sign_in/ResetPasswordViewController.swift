//
//  SendPasswordViewController.swift
//  pochi
//
//  Created by Akiho on 2016/12/16.
//  Copyright © 2016年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let disposeBag: DisposeBag = DisposeBag()
    fileprivate var formDelegate: FormDelegate!
    private var dataSource: ResetPasswordDataSource!
    private var footerView: FooterBtnView!
    
    private let viewModel: ResetPasswordViewModel = ResetPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupInput()
        setupTableView()
        observeTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        formDelegate.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        formDelegate.reset()
    }
    
    private func setupInput() {
        formDelegate = FormDelegate(scrollView: tableView)
    }
    
    private func setupTableView() {
        dataSource = ResetPasswordDataSource(tableView: tableView, delegate: self)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: 40))
        headerView.backgroundColor = UIColor.backgroundColor()
        tableView.tableHeaderView = headerView
        
        footerView = FooterBtnView.instance()
        footerView.setBtnTitle(title: "パスワードを再設定する")
        tableView.tableFooterView = footerView
        
        dataSource.bind()
    }
    
    private func observeTableView() {
        footerView.observeBtn
            .filter({ !self.viewModel.isSending })
            .asObservable()
            .do(onNext: {
                self.view.endEditing(true)
            })
            .do(onNext: {
                SVProgressHUD.show(withStatus: "パスワード送信中...")
            })
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap({ _ -> Observable<Bool> in
                return self.viewModel.resetPassword()
                    .map({ _ in true })
                    .catchErrorJustReturn(false)
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result {
                    SVProgressHUD.showSuccess(withStatus: "新しいパスワードを送信しました")
                } else {
                    SVProgressHUD.showError(withStatus: "送信に失敗しました")
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

extension ResetPasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate.setActiveTextInput(field: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        formDelegate.setActiveTextInput(field: nil)
        return true
    }
}
