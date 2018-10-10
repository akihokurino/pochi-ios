//
//  LicenseListViewController.swift
//  pochi
//
//  Created by akiho on 2017/09/03.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LicenseListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: LicenseListDataSource!
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTableView() {
        let path = Bundle.main.path(forResource: "Acknowledgements", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let items: NSArray = dict!.object(forKey: "PreferenceSpecifiers") as! NSArray
        
        let lisences: [String] = items.map({
            ($0 as! NSDictionary).object(forKey: "Title") as! String
        })
        
        dataSource = LicenseListDataSource(tableView: tableView)
        Observable.just(lisences)
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }
}
