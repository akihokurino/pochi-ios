//
//  EditSitterProfileViewController.swift
//  pochi
//
//  Created by akiho on 2017/02/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditSitterProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: EditSitterProfileDataSource!
    fileprivate var formDelegate: FormDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        setupInput()
        observeSaveBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        formDelegate.setup()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        formDelegate.reset()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupInput() {
        formDelegate = FormDelegate(scrollView: tableView)
    }

    private func save() {
        // TODO: 保存
        self.navigationController!.popViewController(animated: true)
    }
    
    private func setupTableView() {
        dataSource = EditSitterProfileDataSource(tableView: tableView, delegate: self)
        dataSource.bind()
    }
    
    private func observeSaveBtn() {
        saveBtn.rx.tap.asDriver()
            .drive(onNext: {
                self.save()
            })
            .addDisposableTo(disposeBag)
    }
}

extension EditSitterProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        formDelegate.setActiveTextInput(field: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        formDelegate.setActiveTextInput(field: nil)
        return true
    }
}

extension EditSitterProfileViewController: UITextViewDelegate {
    
}
