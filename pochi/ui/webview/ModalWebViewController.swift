//
//  WebViewController.swift
//  pochi
//
//  Created by akiho on 2016/12/17.
//  Copyright © 2016年 akiho. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class ModalWebViewController: UIViewController {
    
    static func instantiate(title: String, url: URL) -> ModalWebViewController {
        let vc = R.storyboard.webView.modalWebViewController()!
        vc.headerTitle = title
        vc.url = url
        return vc
    }
    
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    @IBOutlet weak var headerItem: UINavigationItem!
    
    private var webView : WKWebView?
    fileprivate var url: URL?
    private let disposeBag: DisposeBag = DisposeBag()
    fileprivate var headerTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavigation()
        loadWebView()
        observeCancelBtn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupNavigation() {
        headerItem.title = headerTitle
    }
    
    private func loadWebView() {
        let origin: CGPoint = CGPoint(x: 0, y: 64)
        let size: CGSize = UIScreen.main.bounds.size
        webView = WKWebView(frame: CGRect(origin: origin, size: size))
        
        view.addSubview(webView!)
        
        let request = NSURLRequest(url: url!)
        webView!.load(request as URLRequest)
    }
    
    private func observeCancelBtn() {
        cancelBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                self.back()
            })
            .addDisposableTo(disposeBag)
    }
    
    private func back() {
        dismiss(animated: true, completion: nil)
    }
}

