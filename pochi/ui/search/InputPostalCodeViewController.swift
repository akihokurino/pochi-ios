//
//  InputPostalCodeViewController.swift
//  pochi
//
//  Created by akiho on 2017/05/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InputPostalCodeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    fileprivate var formDelegate: FormDelegate!
    private var dataSource: InputPostalCodeDataSource!
    private var footerView: FooterBtnView!
    private let viewModel: InputPostalCodeViewModel = InputPostalCodeViewModel()
    
    func bind(zipCode: String) {
        viewModel.bind(data: InputPostalCodeData.SendData(postalCode: zipCode))
    }
    
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
        dataSource = InputPostalCodeDataSource(tableView: tableView, delegate: self, container: self)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: 40))
        headerView.backgroundColor = UIColor.backgroundColor()
        tableView.tableHeaderView = headerView
        
        footerView = FooterBtnView.instance()
        footerView.setBtnTitle(title: "検索")
        tableView.tableFooterView = footerView
        
        dataSource.bind(zipCode: viewModel.currentZipCode)
    }
    
    private func observeTableView() {
        footerView.observeBtn
            .drive(onNext: { _ in
                let viewControllers: [UIViewController] = self.navigationController?.viewControllers ?? []
                let from = viewControllers[viewControllers.count - 2]
                (from as? SearchResultViewController)?.bind(zipCode: self.viewModel.currentZipCode, forceRefresh: true)
                self.navigationController?.popViewController(animated: true)
            })
            .addDisposableTo(disposeBag)
        
        dataSource.observeInput()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { data in
                self.viewModel.bind(data: data)
                self.footerView.setBtnState(state: data.isAllInputFilled() ? .active : .inActive)
            })
            .addDisposableTo(disposeBag)
    }
}

extension InputPostalCodeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate.setActiveTextInput(field: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        formDelegate.setActiveTextInput(field: nil)
        return true
    }
}

