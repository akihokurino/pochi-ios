//
//  SitterDetailViewController.swift
//  pochi
//
//  Created by akiho on 2017/02/24.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class SitterDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var tableDelegate: SearchTableDelegate!
    private var dialogDelegate: DialogDelegate!
    private var isTransparentNavigationBar: Bool = true
    private var dataSource: SitterDetailDataSource!
    private var viewModel: SitterDetailViewModel!
    private var messageLinkView: MessageLinkView!
    
    func bind(sitter: Sitter) {
        self.viewModel = SitterDetailViewModel(sitter: sitter)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        setupDialog()
        observeTableView()
        observeMessageLinkView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isTransparentNavigationBar {
            hideNavigationBar()
        } else {
            showNavigationBar()
        }
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        showNavigationBar()
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupDialog() {
        dialogDelegate = DialogDelegate(container: self)
    }
    
    private func setupTableView() {
        tableDelegate = SearchTableDelegate(tableView: tableView)
        dataSource = SitterDetailDataSource(tableView: tableView, sitter: viewModel.justSitter)
        
        tableView.tableHeaderView = tableDelegate.generateImageHeader(url: URL(string: viewModel.justSitter.mainImage)!)
        
        messageLinkView = MessageLinkView.instance()
        self.view.addSubview(messageLinkView)
        
        dataSource.bind()
    }
    
    private func observeTableView() {
        tableView.rx.contentOffset.asDriver()
            .drive(onNext: { offset in
                let offsetY = offset.y
                if offsetY > 80 {
                    if self.isTransparentNavigationBar {
                        self.showNavigationBar()
                    }
                    self.isTransparentNavigationBar = false
                } else {
                    if !self.isTransparentNavigationBar {
                        self.hideNavigationBar()
                    }
                    self.isTransparentNavigationBar = true
                }
            })
            .addDisposableTo(disposeBag)
        
        dataSource.observeAction
            .drive(onNext: { event in
                switch event {
                case .ReviewMore:
                    self.viewModel.fetchReviewsEachPage()
                case .Map:
                    self.showMapDialog()
                case .None:
                    break
                }
            })
            .addDisposableTo(disposeBag)
        
        dataSource.observeSelectPhoto
            .filter({ $0 != nil })
            .drive(onNext: { image in
                let to = PhotoPagerViewController.instantiate(
                    images: self.viewModel.justSitter.interiorImages,
                    selectImage: image!)
                self.present(to as UIViewController, animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
        
        dataSource.bind(reviews: viewModel.observeReviews)
        dataSource.bind(state: viewModel.observeStateReviewPagination)
        dataSource.bind(sitter: viewModel.observeSitter)
        dataSource.bind(dogs: viewModel.observeSitterDogs)
        dataSource.bind(reviewTotalCount: viewModel.observeReviewTotalCount)
    }
    
    private func observeMessageLinkView() {
        messageLinkView.observeMessageBtn.asObservable()
            .filter({ !self.viewModel.isRequesting })
            .observeOn(MainScheduler.instance)
            .do(onNext: {
                if AppUserStore.shared.restore() == nil {
                    let to = SignUpPromotionViewController.instantiate()
                    self.present(to as UIViewController, animated: false, completion: nil)
                }
            })
            .filter({ AppUserStore.shared.restore() != nil })
            .do(onNext: {
                SVProgressHUD.show(withStatus: "メッセージ画面へ移動中...")
            })
            .observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap({ _ -> Observable<Booking?> in
                return self.viewModel.createBooking()
                    .map({ Optional($0) })
                    .catchErrorJustReturn(nil)
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { booking in
                if let _booking = booking {
                    SVProgressHUD.dismiss()
                    let to = MessageNavigationViewController.instantiate(booking: _booking)
                    self.present(to as UIViewController, animated: true, completion: nil)
                } else {
                    SVProgressHUD.showError(withStatus: "メッセージ画面へ遷移できませんでした")
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    private func hideNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func showNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    private func showMapDialog() {
        guard let address = self.viewModel.justSitter.address else {
            return
        }
        
        dialogDelegate.showMapDialog()
            .asDriver()
            .drive(onNext: { action in
                switch action {
                case .Google:
                    MapDelegate.openGoogleMap(latitude: address.latitude,
                                              longitude: address.longitude)
                case .Apple:
                    MapDelegate.openAppleMap(latitude: address.latitude,
                                             longitude: address.longitude)
                case .None:
                    break
                }
            })
            .addDisposableTo(disposeBag)
    }
}
