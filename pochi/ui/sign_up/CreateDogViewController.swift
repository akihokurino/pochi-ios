//
//  CreateDogViewController.swift
//  pochi
//
//  Created by akiho on 2016/12/17.
//  Copyright © 2016年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import FirebaseAuth

class CreateDogViewController: UIViewController {
    
    @IBOutlet weak var skipBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    fileprivate var formDelegate: FormDelegate!
    private var dataSource: CreateDogDataSource!
    private var footerView: FooterBtnView!
    
    private let viewModel: CreateDogViewModel = CreateDogViewModel()
    private var signUpViewModel: SignUpViewModel? = nil
    
    func sync(viewModel: SignUpViewModel) {
        self.signUpViewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupInput()
        setupTableView()
        observeSkipBtn()
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
        dataSource = CreateDogDataSource(tableView: tableView, delegate: self)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: 40))
        headerView.backgroundColor = UIColor.backgroundColor()
        tableView.tableHeaderView = headerView
        
        footerView = FooterBtnView.instance()
        footerView.setBtnTitle(title: "登録する")
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
                SVProgressHUD.show(withStatus: "登録中...")
            })
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap({ _ -> Observable<Bool> in
                return self.signUpViewModel!.signUp()
                    .flatMap({ appUser -> Observable<[Dog]> in
                        return self.viewModel.create(user: appUser, more: self.dataSource.getMoreDogData())
                    })
                    .map({ _ in true })
                    .observeOn(MainScheduler.instance)
                    .catchError({ error -> Observable<Bool> in
                        let code = (error as NSError).code
                        if let firebaseError = AuthErrorCode(rawValue: code) {
                            switch firebaseError {
                            case .emailAlreadyInUse:
                                SVProgressHUD.showError(withStatus: "お使いのEmailはすでに登録されています")
                            case .invalidEmail:
                                SVProgressHUD.showError(withStatus: "有効なEmailを入力してください")
                            case .weakPassword:
                                SVProgressHUD.showError(withStatus: "パスワードが短すぎます")
                            default:
                                SVProgressHUD.showError(withStatus: "登録に失敗しました")
                            }
                        }
                        
                        return Observable.just(false)
                    })
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result {
                    SVProgressHUD.showSuccess(withStatus: "登録しました")
                    self.toRoot()
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

    private func observeSkipBtn() {
        skipBtn.rx.tap
            .filter({ !self.viewModel.isLoading })
            .asObservable()
            .observeOn(MainScheduler.instance)
            .do(onNext: {
                self.view.endEditing(true)
            })
            .do(onNext: {
                SVProgressHUD.show(withStatus: "登録中...")
            })
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap({ _ -> Observable<Bool> in
                return self.signUpViewModel!.signUp()
                    .map({ _ in true })
                    .observeOn(MainScheduler.instance)
                    .catchError({ error -> Observable<Bool> in
                        let code = (error as NSError).code
                        if let firebaseError = AuthErrorCode(rawValue: code) {
                            switch firebaseError {
                            case .emailAlreadyInUse:
                                SVProgressHUD.showError(withStatus: "お使いのEmailはすでに登録されています")
                            case .invalidEmail:
                                SVProgressHUD.showError(withStatus: "有効なEmailを入力してください")
                            case .weakPassword:
                                SVProgressHUD.showError(withStatus: "パスワードが短すぎます")
                            default:
                                SVProgressHUD.showError(withStatus: "登録に失敗しました")
                            }
                        }
                        
                        return Observable.just(false)
                    })
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result {
                    SVProgressHUD.showSuccess(withStatus: "登録しました")
                    self.toRoot()
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    private func toRoot() {
        RootViewController.instantiateForRoot()
        UIApplication.shared.requestRemoreNotification()
    }
}

extension CreateDogViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate.setActiveTextInput(field: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        formDelegate.setActiveTextInput(field: nil)
        return true
    }
}
