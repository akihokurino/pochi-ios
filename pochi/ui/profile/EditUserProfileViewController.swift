//
//  EditUserProfileViewController.swift
//  pochi
//
//  Created by akiho on 2017/02/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class EditUserProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: EditUserProfileDataSource!
    private var dialogDelegate: DialogDelegate!
    fileprivate var formDelegate: FormDelegate!
    private var photoPickerDelegate: PhotoPickerDelegate<EditUserProfileViewController>!
    fileprivate var tableHeaderView: EditProfileHeaderView!
    fileprivate let viewModel: EditUserProfileViewModel = EditUserProfileViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.saveBtn.isEnabled = false
        
        setupDialog()
        setupPhotoPicker()
        setupTableView()
        setupInput()
        observeSaveBtn()
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
    
    private func setupPhotoPicker() {
        photoPickerDelegate = PhotoPickerDelegate(container: self)
    }
    
    private func setupInput() {
        formDelegate = FormDelegate(scrollView: tableView, initBottomInsets: 100)
    }

    private func setupDialog() {
        dialogDelegate = DialogDelegate(container: self)
    }
    
    private func setupTableView() {
        dataSource = EditUserProfileDataSource(tableView: tableView, delegate: self)
        
        tableHeaderView = EditProfileHeaderView.instance()
        if !viewModel.appUser.overview.iconUri.isEmpty {
            tableHeaderView.setIcon(url: URL(string: viewModel.appUser.overview.iconUri)!)
        }
        tableView.tableHeaderView = tableHeaderView
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    private func observeSaveBtn() {
        saveBtn.rx.tap.asObservable()
            .filter({ !self.viewModel.isLoading })
            .observeOn(MainScheduler.instance)
            .do(onNext: {
                self.view.endEditing(true)
            })
            .do(onNext: {
                SVProgressHUD.show(withStatus: "更新中...")
            })
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap({_ -> Observable<AppUser?> in
                return self.viewModel.update()
                    .map({ Optional($0) })
                    .catchErrorJustReturn(nil)
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { appUser in
                if let _appUser = appUser {
                    SVProgressHUD.showSuccess(withStatus: "更新しました")
                    let viewControllers: [UIViewController] = self.navigationController?.viewControllers ?? []
                    let from = viewControllers[viewControllers.count - 2]
                    (from as? UserProfileViewController)?.bind(user: _appUser)
                    self.navigationController!.popViewController(animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: "更新に失敗しました")
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeTableView() {
        tableHeaderView.observeEditBtn
            .flatMap({ _ -> Driver<DialogDelegate.UploadMenu> in
                return self.dialogDelegate.showUploadMenuDialog().asDriver()
            })
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
        
        dataSource.observeInput
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { data in
                self.viewModel.bind(data: data)
                self.saveBtn.isEnabled = data.isAllInputFilled()
            })
            .addDisposableTo(disposeBag)
        
        dataSource.bind(user: viewModel.appUser)
    }
}

extension EditUserProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate.setActiveTextInput(field: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        formDelegate.setActiveTextInput(field: nil)
        return true
    }
}

extension EditUserProfileViewController: UITextViewDelegate {
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
}

extension EditUserProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            tableHeaderView.setIcon(image: editedImage)
            self.viewModel.bind(image: editedImage)
            self.saveBtn.isEnabled = true
        } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            tableHeaderView.setIcon(image: pickedImage)
            self.viewModel.bind(image: pickedImage)
            self.saveBtn.isEnabled = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditUserProfileViewController: UINavigationControllerDelegate {
    
}
