//
//  ReviewTaskViewController.swift
//  pochi
//
//  Created by akiho on 2017/05/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class ReviewTaskViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    fileprivate var dataSource: ReviewTaskDataSource!
    fileprivate var footerView: FooterBtnView!
    fileprivate var formDelegate: FormDelegate!
    private var pickerTextField: PickerTextField!
    fileprivate var viewModel: ReviewTaskViewModel!
    private var tableHeaderView: ReviewHeaderView!
    
    func bind(task: UserTask) {
        viewModel = ReviewTaskViewModel(task: task)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupInput()
        setupPickerView()
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
    
    private func setupPickerView() {
        pickerTextField = PickerTextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        pickerTextField.alpha = 0.0
        pickerTextField.customDelegate = self
        self.pickerTextField.setup(dataList: ["1","2","3","4","5"])
        self.view.addSubview(pickerTextField)
    }
    
    private func setupTableView() {
        dataSource = ReviewTaskDataSource(tableView: tableView, delegate: self)
        
        tableHeaderView = ReviewHeaderView.instance()
        tableView.tableHeaderView = tableHeaderView

        footerView = FooterBtnView.instance()
        footerView.setBtnTitle(title: "送信する")
        tableView.tableFooterView = footerView
        
        dataSource.bind()
    }
    
    private func observeTableView() {
        dataSource.observeAction
            .drive(onNext: { action in
                switch action {
                case .review:
                    self.pickerTextField.becomeFirstResponder()
                case .none:
                    break
                }
            })
            .addDisposableTo(disposeBag)
        
        footerView.observeBtn.asObservable()
            .filter({ !self.viewModel.isLoading })
            .observeOn(MainScheduler.instance)
            .do(onNext: {
                SVProgressHUD.show(withStatus: "レビュー送信中...")
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
                    SVProgressHUD.showSuccess(withStatus: "送信を完了しました")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: "送信に失敗しました")
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.observeReviewee.filter({ $0 != nil })
            .drive(onNext: { user in
                self.tableHeaderView.bind(user: user!, task: self.viewModel.task)
            })
            .addDisposableTo(disposeBag)
    }
}

extension ReviewTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        formDelegate.setActiveTextInput(field: textView)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        viewModel.sync(content: textView.text)
        footerView.setBtnState(state: viewModel.reviewData.isValid ? .active : .inActive)
    }
}

extension ReviewTaskViewController: PickerTextFieldDelegate {
    func select(value: String) {
        if !value.isEmpty {
            viewModel.sync(score: Int(value)!)
            dataSource.bind(score: Int(value)!)
            footerView.setBtnState(state: viewModel.reviewData.isValid ? .active : .inActive)
        }
    }
}

