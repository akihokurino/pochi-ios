//
//  EditPasswordViewController.swift
//  pochi
//
//  Created by akiho on 2017/06/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class EditPasswordViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    private let disposeBag: DisposeBag = DisposeBag()
    fileprivate var formDelegate: FormDelegate!
    private var dataSource: EditPasswordDataSource!
    private var footerView: FooterBtnView!
    private let viewModel: EditPasswordViewModel = EditPasswordViewModel()
    
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
    
    private func setupTableView() {
        dataSource = EditPasswordDataSource(tableView: tableView, delegate: self)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: 40))
        headerView.backgroundColor = UIColor.backgroundColor()
        tableView.tableHeaderView = headerView
        
        footerView = FooterBtnView.instance()
        footerView.setBtnTitle(title: "変更する")
        tableView.tableFooterView = footerView
        
        dataSource.bind()
    }
    
    private func observeTableView() {
        footerView.observeBtn
            .asObservable()
            .filter({ !self.viewModel.isLoading })
            .observeOn(MainScheduler.instance)
            .do(onNext: {
                self.view.endEditing(true)
            })
            .do(onNext: {
                SVProgressHUD.show(withStatus: "パスワード変更中。。。")
            })
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap({ _ -> Observable<Bool> in
                return self.viewModel.update()
                    .map({ _ in true })
                    .catchErrorJustReturn(false)
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result {
                    SVProgressHUD.showSuccess(withStatus: "パスワードを変更しました")
                    self.navigationController!.popViewController(animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: "パスワードの変更に失敗しました")
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

extension EditPasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate.setActiveTextInput(field: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        formDelegate.setActiveTextInput(field: nil)
        return true
    }
}
