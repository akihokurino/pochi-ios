//
//  OtherViewController.swift
//  pochi
//
//  Created by akiho on 2017/01/05.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift

class OtherViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: OtherDataSource!
    private var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        setupTableView()
        observeTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        self.navigationItem.backBarButtonItem = backBtn
    }
    
    private func setupTableView() {
        dataSource = OtherDataSource(tableView: self.tableView)
        dataSource.bind()
    }
    
    private func observeTableView() {
        dataSource.observeSelectItem
            .drive(onNext: { type in
                switch type {
                case .Notice:
                    self.performSegue(withIdentifier: R.segue.otherViewController.fromOtherToNoticeList, sender: nil)
                case .Profile:
                    let to = UserProfileNavigationController.instantiate(user: AppUserStore.shared.restore()!)
                    self.present(to, animated: true, completion:  nil)
                case .DogProfile:
                    let to = DogProfileNavigationController.instantiate(user: AppUserStore.shared.restore()!)
                    self.present(to, animated: true, completion: nil)
                case .HostProfile:
                    let to = MySitterProfileNavigationController.instantiate()
                    self.present(to, animated: true, completion: nil)
                case .SettingBank:
                    self.performSegue(withIdentifier: R.segue.otherViewController.fromOtherToSettingBankAccount, sender: nil)
                case .ReturnPoint:
                    self.performSegue(withIdentifier: R.segue.otherViewController.fromOtherToReturnPoint, sender: nil)
                case .FinishedKeep:
                    self.performSegue(withIdentifier: R.segue.otherViewController.fromOtherToClosedKeepBookingList, sender: nil)
                case .FinishedLeave:
                    self.performSegue(withIdentifier: R.segue.otherViewController.fromOtherToClosedLeaveBookingList, sender: nil)
                case .Setting:
                    self.performSegue(withIdentifier: R.segue.otherViewController.fromOtherToSetting, sender: nil)
                case .Help:
                    self.toHelpViewController()
                case .Support:
                    self.toSupportViewController()
                case .ReportBug:
                    self.toReportViewController()
                default:
                    break
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    private func toHelpViewController() {
        let to = ModalWebViewController.instantiate(title: "ヘルプ", url: AppConfig.helpURL)
        present(to as UIViewController, animated: true, completion: nil)
    }
    
    private func toSupportViewController() {
        let to = ModalWebViewController.instantiate(title: "安心サポート", url: AppConfig.supportURL)
        present(to as UIViewController, animated: true, completion: nil)
    }
    
    private func toReportViewController() {
        let to = ModalWebViewController.instantiate(title: "不具合報告はこちら", url: AppConfig.reportURL)
        present(to as UIViewController, animated: true, completion: nil)
    }
}
