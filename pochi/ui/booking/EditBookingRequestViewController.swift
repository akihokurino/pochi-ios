//
//  EditBookingRequestViewController.swift
//  pochi
//
//  Created by akiho on 2017/10/21.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class EditBookingRequestViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    fileprivate var formDelegate: FormDelegate!
    private var dataSource: EditBookingRequestDataSource!
    fileprivate var viewModel: EditBookingRequestViewModel!
    private var footerView: FooterBtnWithLinkView!
    
    func bind(booking: Booking) {
        self.viewModel = EditBookingRequestViewModel(booking: booking)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        setupTableView()
        setupInput()
        observeTableView()
        observeDogPromotion()
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
        dataSource = EditBookingRequestDataSource(tableView: tableView, delegate: self)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: 40))
        headerView.backgroundColor = UIColor.backgroundColor()
        tableView.tableHeaderView = headerView
        
        footerView = FooterBtnWithLinkView.instance(btnTitle: "保存", linkTitle: "よくある質問はこちら")
        tableView.tableFooterView = footerView
        
        dataSource.bind(booking: viewModel.booking)
    }
    
    private func observeTableView() {
        dataSource.observeInput
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { data in
                self.viewModel.bind(data: data)
                self.footerView.setBtnState(state: data.isAllInputFilled(availablePoint: self.viewModel.justAvailablePoint) ? .Active : .InActive)
            })
            .addDisposableTo(disposeBag)
        
        footerView.observeLink
            .drive(onNext: {
                self.toHelpViewController()
            })
            .addDisposableTo(disposeBag)
        
        footerView.observeBtn.asObservable()
            .filter({ !self.viewModel.isRequesting })
            .observeOn(MainScheduler.instance)
            .do(onNext: {
                self.view.endEditing(true)
            })
            .do(onNext: {
                SVProgressHUD.show(withStatus: "金額計算中...")
            })
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap({ _ -> Observable<Bool> in
                return self.viewModel.checkCoupon()
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result {
                    self.viewModel.checkBooking()
                        .observeOn(MainScheduler.instance)
                        .subscribe(onNext: { booking in
                            SVProgressHUD.dismiss()
                            let viewControllers: [UIViewController] = self.navigationController?.viewControllers ?? []
                            let from = viewControllers[viewControllers.count - 2]
                            (from as? MessageViewController)?.bind(booking: booking)
                            self.navigationController?.popViewController(animated: true)
                        }, onError: { e in
                            SVProgressHUD.showError(withStatus: "入力データが不正です")
                        })
                        .addDisposableTo(self.disposeBag)
                } else {
                    SVProgressHUD.showError(withStatus: "クーポンコードが不正です")
                }
            })
            .addDisposableTo(disposeBag)
        
        dataSource.bind(booking: viewModel.booking, dogs: viewModel.observeUserDogs)
        dataSource.bind(point: viewModel.observeAvailablePoint)
    }
    
    private func toHelpViewController() {
        let to = ModalWebViewController.instantiate(title: "ヘルプ", url: AppConfig.helpURL)
        present(to as UIViewController, animated: true, completion: nil)
    }
    
    private func observeDogPromotion() {
        viewModel.observeUserDogs
            .skip(1)
            .do(onNext: { dogs in
                if dogs.isEmpty && !self.viewModel.isSitter && !self.viewModel.isShowRegisterDogPromotion {
                    let to = RegisterDogPromotionViewController.instantiate(delegate: self)
                    self.present(to, animated: false, completion: nil)
                }
            })
            .drive(onNext: { dogs in
                
            })
            .addDisposableTo(disposeBag)
    }
}

extension EditBookingRequestViewController: RegisterDogCallBack {
    func onRegister() {
        self.viewModel.reloadDogs()
    }
}

extension EditBookingRequestViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate.setActiveTextInput(field: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        formDelegate.setActiveTextInput(field: nil)
        return true
    }
}
