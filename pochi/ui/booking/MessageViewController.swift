//
//  MessageViewController.swift
//  pochi
//
//  Created by akiho on 2017/02/10.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class MessageViewController: UIViewController {
    
    @IBOutlet weak var headerItem: UINavigationItem!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var detailViewHeightConstraint: NSLayoutConstraint!
    
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    fileprivate var tableDelegate: MessageTableDelegate!
    fileprivate var inputDelegate: MessageInputDelegate!
    private var photoPickerDelegate: PhotoPickerDelegate<MessageViewController>!
    private var dataSource: MessageDataSource!
    fileprivate var messageInputView: MessageInputView!
    fileprivate var viewModel: MessageViewModel!
    private var dialogDelegate: MessageDialogDelegate!
    
    private var actionVC: BookingActionViewController {
        return self.childViewControllers[0] as! BookingActionViewController
    }
    
    func bind(booking: Booking) {
        if viewModel == nil {
            viewModel = MessageViewModel(booking: booking)
        } else {
            viewModel.sync(booking: booking)
            actionVC.bind(booking: booking)
        }
        
        navigationItem.title = booking.sitter.nickname
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupDialog()
        setupNavigation()
        setupPhotoPicker()
        setupMessageInputView()
        setupTableView()
        observeBackBtn()
        observeMessageInputView()
        observeTableView()
        
        actionVC.bind(booking: viewModel.booking)
        actionVC.observeMenuAction(menuBtn: menuBtn)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableDelegate.setup()
        inputDelegate.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tableDelegate.reset()
        inputDelegate.reset()
    }
    
    private func setupDialog() {
        dialogDelegate = MessageDialogDelegate(container: self)
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
        
        updateNavigationMenu(booking: viewModel.booking)
    }
    
    private func setupPhotoPicker() {
        photoPickerDelegate = PhotoPickerDelegate(container: self)
    }
    
    private func setupMessageInputView() {
        messageInputView = MessageInputView.instance()
        messageInputView.textView.delegate = self
        messageInputView.setup()
        self.view.addSubview(messageInputView)
    }
    
    private func setupTableView() {
        dataSource = MessageDataSource(tableView: tableView)
        tableDelegate = MessageTableDelegate(tableView: tableView)
        inputDelegate = MessageInputDelegate(inputView: messageInputView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(showKeyboardWhenTap(gestureRecognizer:)))
        tableView.addGestureRecognizer(tapGestureRecognizer)
        
        tableView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 48, 0)
        
        tableView.tableFooterView = FooterLoadingView.instance()
    }
    
    private func observeMessageInputView() {
        messageInputView.observeSendBtn
            .asObservable()
            .filter({ _ in !self.messageInputView.textView.text.isEmpty })
            .flatMap({ _ -> Observable<Bool> in
                return self.viewModel.createMessage(text: self.messageInputView.textView.text)
                    .map({ _ in true })
                    .catchErrorJustReturn(false)
            })
            .subscribe(onNext: { result in
                if result {
                    let _ = self.messageInputView.textView.resignFirstResponder()
                }
            })
            .addDisposableTo(disposeBag)
        
        messageInputView.observeMediaBtn
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
    }
    
    private func observeTableView() {
        viewModel.observeMessages.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        viewModel.observeEvent
            .drive(onNext: { event in
                switch event {
                case .none:
                    break
                case .refreshed:
                    self.tableView.tableFooterView?.isHidden = false
                case .completedMessagePagination:
                    self.tableView.tableFooterView?.isHidden = true
                }
            })
            .addDisposableTo(disposeBag)
        
        tableView.rx.contentOffset.asDriver()
            .drive(onNext: { offset in
                if offset.y + self.tableView.frame.size.height > self.tableView.contentSize.height && self.tableView.isDragging {
                    self.viewModel.fetchMessagesEachPage()
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    @objc func showKeyboardWhenTap(gestureRecognizer: UITapGestureRecognizer){
        inputDelegate.hideKeyboard()
    }
    
    private func observeBackBtn() {
        backBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }
    
    func refresh() {
        self.viewModel.refresh()
    }
    
    func updateNavigationMenu(booking: Booking) {
        if booking.status != .confirm {
            menuBtn.isEnabled = false
            menuBtn.tintColor = UIColor.clear
        } else {
            menuBtn.isEnabled = true
            menuBtn.tintColor = UIColor.white
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.messageViewController.fromMessageToEditRequest.identifier {
            let to = segue.destination as! EditBookingRequestViewController
            to.bind(booking: viewModel.booking)
        }
    }
}

extension MessageViewController: UITextViewDelegate {
    
}

extension MessageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if info[UIImagePickerControllerOriginalImage] != nil {
            let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            SVProgressHUD.show(withStatus: "アップロード中...")
            
            self.viewModel.createMessage(image: image).asObservable()
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { _ in
                    SVProgressHUD.showSuccess(withStatus: "アップロードが完了しました")
                }, onError: { e in
                    SVProgressHUD.showError(withStatus: "アップロードに失敗しました")
                })
                .addDisposableTo(disposeBag)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MessageViewController: UINavigationControllerDelegate {
    
}


