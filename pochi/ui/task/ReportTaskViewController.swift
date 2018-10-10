//
//  ReportTaskViewController.swift
//  pochi
//
//  Created by akiho on 2017/05/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class ReportTaskViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var photoPickerDelegate: PhotoPickerDelegate<ReportTaskViewController>!
    private var dialogDelegate: DialogDelegate!
    private let disposeBag: DisposeBag = DisposeBag()
    fileprivate var dataSource: ReportTaskDataSource!
    fileprivate var footerView: FooterBtnView!
    fileprivate var formDelegate: FormDelegate!
    fileprivate var viewModel: ReportTaskViewModel!
    
    func bind(task: UserTask) {
        viewModel = ReportTaskViewModel(task: task)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupInput()
        setupDialog()
        setupPhotoPicker()
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
    
    private func setupPhotoPicker() {
        photoPickerDelegate = PhotoPickerDelegate(container: self)
    }
    
    private func setupDialog() {
        dialogDelegate = DialogDelegate(container: self)
    }

    private func setupTableView() {
        dataSource = ReportTaskDataSource(tableView: tableView, delegate: self)
        
        footerView = FooterBtnView.instance()
        footerView.setBtnTitle(title: "送信する")
        tableView.tableFooterView = footerView
    
        dataSource.bind()
    }
    
    private func observeTableView() {
        dataSource.observeAction
            .drive(onNext: { action in
                switch action {
                case .none:
                    break
                case .upload:
                    self.selectPhoto()
                }
            })
            .addDisposableTo(disposeBag)
        
        footerView.observeBtn.asObservable()
            .filter({ !self.viewModel.isLoading })
            .observeOn(MainScheduler.instance)
            .do(onNext: {
                SVProgressHUD.show(withStatus: "日報送信中...")
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
    }
    
    private func selectPhoto() {
        self.dialogDelegate.showUploadMenuDialog()
            .asDriver()
            .drive(onNext: { menu in
                switch menu {
                case .SelectLibrary:
                    self.photoPickerDelegate.selectLibrary()
                case .TakePicture:
                    self.photoPickerDelegate.takePhoto()
                case .Cancel:
                    break
                }
            })
            .addDisposableTo(disposeBag)
    }
}

extension ReportTaskViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            viewModel.sync(image: image)
            footerView.setBtnState(state: viewModel.reportData.isValid ? .active : .inActive)
            dataSource.bind(image: image)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ReportTaskViewController: UINavigationControllerDelegate {
    
}

extension ReportTaskViewController: UITextViewDelegate {
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
        footerView.setBtnState(state: viewModel.reportData.isValid ? .active : .inActive)
    }
}


