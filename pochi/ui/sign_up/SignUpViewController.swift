//
//  SignUpViewController.swift
//  pochi
//
//  Created by Akiho on 2016/12/14.
//  Copyright © 2016年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FBSDKCoreKit
import FBSDKLoginKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    private let disposeBag: DisposeBag = DisposeBag()
    fileprivate var formDelegate: FormDelegate!
    private var dataSource: SignUpDataSource!
    private var footerView: FooterBtnView!
    
    private let viewModel: SignUpViewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        setupInput()
        setupTableView()
        getFacebookUserData()
        observeCancelBtn()
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
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
    }
    
    private func setupInput() {
        formDelegate = FormDelegate(scrollView: tableView)
    }
    
    private func setupTableView() {
        dataSource = SignUpDataSource(tableView: tableView, delegate: self)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: 40))
        headerView.backgroundColor = UIColor.backgroundColor()
        tableView.tableHeaderView = headerView
        
        footerView = FooterBtnView.instance()
        footerView.setBtnTitle(title: "次へ")
        tableView.tableFooterView = footerView
        
        dataSource.bind()
    }
    
    private func observeTableView() {
        footerView.observeBtn
            .drive(onNext: {
                self.performSegue(withIdentifier: R.segue.signUpViewController.fromSignUpToCreateDog, sender: nil)
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
    
    private func observeCancelBtn() {
        cancelBtn.rx.tap
            .asDriver()
            .do(onNext: {
                self.viewModel.deleteFBUser()
            })
            .drive(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.signUpViewController.fromSignUpToCreateDog.identifier {
            let to = segue.destination as! CreateDogViewController
            to.sync(viewModel: self.viewModel)
        }
    }
    
    private func getFacebookUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(
            graphPath: "me",
            parameters: ["fields": "first_name, last_name, email"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            guard let result = result else {
                return
            }

            let userProfile = result as! NSDictionary
            let lastName = userProfile.object(forKey: "last_name") as? String ?? ""
            let firstName = userProfile.object(forKey: "first_name") as? String ?? ""
            let email = userProfile.object(forKey: "email") as? String ?? ""
            
            self.dataSource.bind(auth: FbAuth(lastName: lastName,
                                              firstName: firstName,
                                              email: email))
        })
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate.setActiveTextInput(field: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        formDelegate.setActiveTextInput(field: nil)
        return true
    }
}
