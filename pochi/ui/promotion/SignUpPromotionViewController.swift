//
//  SignUpPromotionViewController.swift
//  pochi
//
//  Created by akiho on 2017/06/09.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FBSDKCoreKit
import FBSDKLoginKit
import SVProgressHUD

class SignUpPromotionViewController: UIViewController {
    
    static func instantiate() -> SignUpPromotionViewController {
        let vc = R.storyboard.promotion.signUpPromotionViewController()!
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }

    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    private var dialogDelegate: DialogDelegate!
    private var fbSDKBtn: FBSDKLoginButton!
    fileprivate var isFbLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear
        
        setupDialog()
        setupFacebookBtn()
        observeCloseBtn()
        observeSignUpBtn()
        observeSignInBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.backgroundColor = UIColor.modalBackgroundColor()
    }
    
    private func setupDialog() {
        dialogDelegate = DialogDelegate(container: self)
    }
    
    private func setupFacebookBtn() {
        fbSDKBtn = FBSDKLoginButton(frame: facebookBtn.frame)
        
        for subView in fbSDKBtn.subviews {
            subView.removeFromSuperview()
        }
        
        fbSDKBtn.setBackgroundImage(nil, for: UIControlState.normal)
        fbSDKBtn.setBackgroundImage(nil, for: UIControlState.application)
        fbSDKBtn.setBackgroundImage(nil, for: UIControlState.highlighted)
        fbSDKBtn.setBackgroundImage(nil, for: UIControlState.reserved)
        fbSDKBtn.setBackgroundImage(nil, for: UIControlState.selected)
        
        fbSDKBtn.setImage(nil, for: UIControlState.normal)
        fbSDKBtn.setImage(nil, for: UIControlState.application)
        fbSDKBtn.setImage(nil, for: UIControlState.highlighted)
        fbSDKBtn.setImage(nil, for: UIControlState.reserved)
        fbSDKBtn.setImage(nil, for: UIControlState.selected)
        
        fbSDKBtn.backgroundColor = UIColor.clear
        
        fbSDKBtn.readPermissions = ["public_profile", "email", "user_birthday"]
        fbSDKBtn.delegate = self
        
        self.facebookBtn.addSubview(fbSDKBtn)
    }
    
    private func observeCloseBtn() {
        closeBtn.rx.tap.asDriver()
            .drive(onNext: {
                self.dismiss(animated: false, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeSignUpBtn() {
        signUpBtn.rx.tap.asDriver()
            .drive(onNext: {
                self.toSignUpViewController()
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeSignInBtn() {
        signInBtn.rx.tap
            .asDriver()
            .flatMap({ _ -> Driver<DialogDelegate.LoginMenu> in
                return self.dialogDelegate.showLoginMenuDialog().asDriver()
            })
            .drive(onNext: { menu in
                switch menu {
                case .None:
                    break
                case .Facebook:
                    self.isFbLogin = true
                    self.fbSDKBtn.sendActions(for: .touchUpInside)
                case .Email:
                    self.toSignInViewController()
                case .Cancel:
                    break
                }
            })
            .addDisposableTo(disposeBag)
    }
   
    private func toSignInViewController() {
        let to = SignInNavigationController.instantiate()
        present(to as UIViewController, animated: true, completion: nil)
    }
    
    fileprivate func toSignUpViewController() {
        let to = SignUpNavigationController.instantiate()
        present(to as UIViewController, animated: true, completion: nil)
    }
}

extension SignUpPromotionViewController: FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!,
                     didCompleteWith result: FBSDKLoginManagerLoginResult!,
                     error: Error?) {
        guard error == nil else {
            return
        }
        
        guard FBSDKAccessToken.current() != nil else {
            return
        }
        
        SVProgressHUD.show(withStatus: "FB認証中...")
        
        if isFbLogin {
            AppUserRepository.shared.authenticate(fbToken: FBSDKAccessToken.current().tokenString)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { appUser in
                    SVProgressHUD.showSuccess(withStatus: "ログインしました")
                    RootViewController.instantiateForRoot()
                }, onError: { e in
                    self.isFbLogin = false
                    SVProgressHUD.showError(withStatus: "認証に失敗しました")
                })
                .addDisposableTo(disposeBag)
        } else {
            AppUserRepository.shared.create(fbToken: FBSDKAccessToken.current().tokenString)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { fireToken in
                    SVProgressHUD.showSuccess(withStatus: "FB認証が完了しました")
                    self.toSignUpViewController()
                }, onError: { e in
                    SVProgressHUD.showError(withStatus: "認証に失敗しました")
                })
                .addDisposableTo(disposeBag)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
}
