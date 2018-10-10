//
//  SearchResultViewController.swift
//  pochi
//
//  Created by akiho on 2017/02/22.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeDateBtn: UIBarButtonItem!
    @IBOutlet weak var navigationTitleItem: UINavigationItem!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var dataSource: SearchResultDataSource!
    private let viewModel: SearchResultViewModel = SearchResultViewModel()
    private var dialogDelegate: DialogDelegate!
    
    func bind(zipCode: String, forceRefresh: Bool = false) {
        self.viewModel.search(zipCode: zipCode)
        if forceRefresh {
            setupNavigation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        setupDialog()
        setupTableView()
        observeTableView()
        observeChangePostalCodeBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
        
        navigationTitleItem.titleView = nil
        
        let customTitleView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        customTitleView.isOpaque = false
        navigationTitleItem.titleView = customTitleView
        
        let titleLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.text = "郵便番号"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = NSTextAlignment.center
        customTitleView.addSubview(titleLabel)
        
        let subTitleLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 25, width: 200, height: 15))
        subTitleLabel.font = UIFont.boldSystemFont(ofSize: 10.0)
        subTitleLabel.text = self.viewModel.currentZipCode
        subTitleLabel.textColor = UIColor.white
        subTitleLabel.textAlignment = NSTextAlignment.center
        customTitleView.addSubview(subTitleLabel)
    }
    
    private func setupDialog() {
        self.dialogDelegate = DialogDelegate(container: self)
    }
    
    private func setupTableView() {
        dataSource = SearchResultDataSource(tableView: tableView)
        let emptyView = EmptyView.instance()
        emptyView.bind(data: EmptyView.DisplayData(message: "ホストが見つかりませんでした"))
        tableView.backgroundView = emptyView
        tableView.backgroundView?.isHidden = true
        
        tableView.tableFooterView = FooterLoadingView.instance()
    }
    
    private func observeTableView() {
        tableView.rx.modelSelected(Sitter.self)
            .asDriver()
            .do(onNext: { item in
                self.viewModel.selectedSitter = item
            })
            .drive(onNext: { _ in
                self.performSegue(withIdentifier: R.segue.searchResultViewController.fromSearchResultToSitterDetail, sender: nil)
            })
            .addDisposableTo(disposeBag)
        
        viewModel.observeSitters.asObservable()
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx.contentOffset.asDriver()
            .drive(onNext: { offset in
                if offset.y + self.tableView.frame.size.height > self.tableView.contentSize.height && self.tableView.isDragging {
                    self.viewModel.fetchSittersEachPage()
                }
            })
            .addDisposableTo(disposeBag)
        
        viewModel.observeEvent
            .drive(onNext: { event in
                switch event {
                case .none:
                    break
                case .invalidPostalCode:
                    self.dialogDelegate.simpleAlert(title: "郵便番号が存在しません")
                case .empty:
                    self.tableView.backgroundView?.isHidden = false
                case .completedSitterPagination:
                    self.tableView.tableFooterView = nil
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeChangePostalCodeBtn() {
        changeDateBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                self.tableView.backgroundView?.isHidden = true
                self.performSegue(withIdentifier: R.segue.searchResultViewController.fromSearchResultToInputPostalCode, sender: nil)
            })
            .addDisposableTo(disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.searchResultViewController.fromSearchResultToSitterDetail.identifier && viewModel.selectedSitter != nil {
            let to = segue.destination as! SitterDetailViewController
            to.bind(sitter: viewModel.selectedSitter!)
        } else if segue.identifier == R.segue.searchResultViewController.fromSearchResultToInputPostalCode.identifier {
            let to = segue.destination as! InputPostalCodeViewController
            to.bind(zipCode: viewModel.currentZipCode)
        }
    }
}
