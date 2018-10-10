//
//  EditDogProfileViewController.swift
//  pochi
//
//  Created by akiho on 2017/02/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class EditDogProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: EditDogProfileDataSource!
    fileprivate var formDelegate: FormDelegate!
    private var dialogDelegate: DialogDelegate!
    private var photoPickerDelegate: PhotoPickerDelegate<EditDogProfileViewController>!
    fileprivate var tableHeaderView: EditProfileHeaderView!
    fileprivate var viewModel: EditDogProfileViewModel!
    
    func bind(dog: Dog) {
        self.viewModel = EditDogProfileViewModel(dog: dog)
    }
       
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
        formDelegate = FormDelegate(scrollView: self.tableView, initBottomInsets: 100)
    }
    
    private func setupDialog() {
        dialogDelegate = DialogDelegate(container: self)
    }
    
    private func setupTableView() {
        dataSource = EditDogProfileDataSource(tableView: tableView, delegate: self)
        
        tableHeaderView = EditProfileHeaderView.instance()
        if !viewModel.dog.iconUrl.isEmpty {
            tableHeaderView.setIcon(url: URL(string: viewModel.dog.iconUrl)!)
        } else {
            tableHeaderView.setIcon(image: R.image.icDefaultDog()!)
        }
        tableView.tableHeaderView = tableHeaderView
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
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
        
        dataSource.bind(dog: viewModel.dog)
    }
    
    private func observeSaveBtn() {
        saveBtn.rx.tap
            .filter({ !self.viewModel.isLoading })
            .observeOn(MainScheduler.instance)
            .do(onNext: {
                self.view.endEditing(true)
            })
            .do(onNext: {
                SVProgressHUD.show(withStatus: "更新中...")
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
                    SVProgressHUD.showSuccess(withStatus: "更新しました")
                    self.navigationController!.popViewController(animated: true)
                } else {
                    SVProgressHUD.showError(withStatus: "更新に失敗しました")
                }
            })
            .addDisposableTo(disposeBag)
    }
}

extension EditDogProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate.setActiveTextInput(field: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        formDelegate.setActiveTextInput(field: nil)
        return true
    }
}

extension EditDogProfileViewController: UITextViewDelegate {
    
}

extension EditDogProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            tableHeaderView.setIcon(image: editedImage)
            viewModel.bind(image: editedImage)
            saveBtn.isEnabled = true
        } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            tableHeaderView.setIcon(image: pickedImage)
            viewModel.bind(image: pickedImage)
            saveBtn.isEnabled = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditDogProfileViewController: UINavigationControllerDelegate {
    
}
