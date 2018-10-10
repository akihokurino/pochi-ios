//
//  DogProfileViewController.swift
//  pochi
//
//  Created by akiho on 2017/02/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DogProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var closeBtn: UIBarButtonItem!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: DogProfileDataSource!
    private var viewModel: DogProfileViewModel!
    
    func bind(user: User) {
        self.viewModel = DogProfileViewModel(user: user)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        setupTableView()
        observeTableView()
        observeAddBtn()
        observeCloseBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        viewModel.fetchDogs()
        dataSource.bind()
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
    }
    
    private func setupTableView() {
        dataSource = DogProfileDataSource(tableView: tableView)
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    private func observeTableView() {
        viewModel.observeDogs.asObservable().bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        dataSource.observeSelectDog
            .skip(1)
            .drive(onNext: { dog in
                self.viewModel.selectedDog = dog
                self.performSegue(withIdentifier: R.segue.dogProfileViewController.fromDogProfileToEdit, sender: nil)
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeAddBtn() {
        addBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                let to = CreateDogModalViewController.instantiate()
                self.present(to, animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeCloseBtn() {
        closeBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.dogProfileViewController.fromDogProfileToEdit.identifier && viewModel.selectedDog != nil {
            let to = segue.destination as! EditDogProfileViewController
            to.bind(dog: self.viewModel.selectedDog!)
        }
    }
}
