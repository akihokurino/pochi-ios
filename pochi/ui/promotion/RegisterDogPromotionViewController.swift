//
//  RegisterDogPromotionViewController.swift
//  pochi
//
//  Created by akiho on 2017/06/10.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol RegisterDogCallBack: class {
    func onRegister()
}

class RegisterDogPromotionViewController: UIViewController {
    
    static func instantiate(delegate: RegisterDogCallBack) -> RegisterDogPromotionViewController {
        let vc = R.storyboard.promotion.registerDogPromotionViewController()!
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = delegate
        return vc
    }

    @IBOutlet weak var createDogBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    private let disposeBag: DisposeBag = DisposeBag()
    fileprivate weak var delegate: RegisterDogCallBack?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
    
        observeCloseBtn()
        observeCreateDogBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.backgroundColor = UIColor.modalBackgroundColor()
    }
    
    private func observeCloseBtn() {
        closeBtn.rx.tap.asDriver()
            .drive(onNext: {
                self.dismiss(animated: false, completion: {
                    self.delegate?.onRegister()
                })
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeCreateDogBtn() {
        createDogBtn.rx.tap.asDriver()
            .drive(onNext: {
                self.toCreateDogViewController()
            })
            .addDisposableTo(disposeBag)
    }
    
    private func toCreateDogViewController() {
        let to = CreateDogModalViewController.instantiate()
        present(to as UIViewController, animated: true, completion: nil)
    }
}
