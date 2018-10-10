//
//  SearchViewController.swift
//  pochi
//
//  Created by akiho on 2017/01/05.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    fileprivate var tableDelegate: SearchTableDelegate!
    fileprivate var isShowNavigationBar: Bool = false
    private var dataSource: SearchDataSource!
    private var headerView: SearchHeaderView!
    fileprivate let viewModel: SearchViewModel = SearchViewModel()
    private var keyboardDelegate: KeyboardDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupKeyboardDelegate()
        setupNavigation()
        setupTableView()
        observeSearchBtn()
        observeTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(!isShowNavigationBar, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func observeSearchBtn() {
        searchBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                self.performSegue(withIdentifier: R.segue.searchViewController.fromSearchToResult, sender: nil)
            })
            .addDisposableTo(disposeBag)
    }
    
    private func setupKeyboardDelegate() {
        keyboardDelegate = KeyboardDelegate(container: self)
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTableView() {
        tableDelegate = SearchTableDelegate(tableView: self.tableView)
        dataSource = SearchDataSource(tableView: self.tableView)
        
        let backgroundView: UIView = UIView(frame: self.tableView.bounds)
        let topBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: self.tableView.bounds.height / 4))
        topBackgroundView.backgroundColor = UIColor.searchHeaderRightColor()
        backgroundView.addSubview(topBackgroundView)
        tableView.backgroundView = backgroundView

        headerView = SearchHeaderView.instance()
        keyboardDelegate.addCloseBtn(textField: headerView.postalCodeTextField)
        headerView.postalCodeTextField.delegate = self
        tableView.tableHeaderView = headerView
        
        tableView.tableFooterView = FooterLoadingView.instance()
    }
    
    private func observeTableView() {
        headerView.observeSearchBtn
            .drive(onNext: {
                self.performSegue(withIdentifier: R.segue.searchViewController.fromSearchToResult, sender: nil)
            })
            .addDisposableTo(disposeBag)
        
        headerView.observeSearchText
            .drive(onNext: { text in
                guard text != nil else {
                    return
                }
                
                self.viewModel.currentZipcode = text!
            })
            .addDisposableTo(disposeBag)
        
        tableView.rx.contentOffset.asDriver()
            .drive(onNext: { offset in
                let offsetY = offset.y
                if offsetY > 165 && !self.isShowNavigationBar {
                    self.isShowNavigationBar = true
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                } else if offsetY <= 165 && self.isShowNavigationBar {
                    self.isShowNavigationBar = false
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                }
                
                if offset.y + self.tableView.frame.size.height > self.tableView.contentSize.height && self.tableView.isDragging {
                    self.viewModel.fetchSittersEachPage()
                }
            })
            .addDisposableTo(disposeBag)
        
        dataSource.observeAction
            .drive(onNext: { action in
                switch action {
                case .none:
                    break
                case .showPromotion:
                    let to = SignUpPromotionViewController.instantiate()
                    self.present(to as UIViewController, animated: false, completion: nil)
                case .reachedBottom:
                    self.viewModel.fetchSittersEachPage()
                }
            })
            .addDisposableTo(disposeBag)
        
        dataSource.observeSelectItem
            .do(onNext: { item in
                self.viewModel.selectedSitter = item
            })
            .drive(onNext: { item in
                guard item != nil else {
                    return
                }
                
                self.performSegue(withIdentifier: R.segue.searchViewController.fromSearchToSitterDetail, sender: nil)
            })
            .addDisposableTo(disposeBag)
        
        viewModel.observeSitters.asObservable()
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        dataSource.bind(histories: viewModel.observeHistories)
        
        viewModel.observeEvent
            .drive(onNext: { event in
                switch event {
                case .none:
                    break
                case .completedSitterPagination:
                    self.tableView.tableFooterView = nil
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.searchViewController.fromSearchToSitterDetail.identifier && viewModel.selectedSitter != nil {
            let to = segue.destination as! SitterDetailViewController
            to.bind(sitter: viewModel.selectedSitter!)
        } else if segue.identifier == R.segue.searchViewController.fromSearchToResult.identifier {
            let to = segue.destination as! SearchResultViewController
            to.bind(zipCode: self.viewModel.currentZipcode)
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
