//
//  WelcomeViewController.swift
//  pochi
//
//  Created by Akiho on 2016/12/13.
//  Copyright © 2016年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FBSDKCoreKit
import FBSDKLoginKit
import SVProgressHUD

class WelcomeViewController: UIViewController {
    
    static func instantiate() -> WelcomeViewController {
        let vc = R.storyboard.welcome.welcomeViewController()!
        return vc
    }
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var linkTextView: UITextView!
    @IBOutlet weak var skipBtn: UIBarButtonItem!
    
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    private var serviceTermsRange: NSRange = NSRange()
    private var privacyPolicyRange: NSRange = NSRange()
    private var dialogDelegate: DialogDelegate!
    private var fbSDKBtn: FBSDKLoginButton!
    fileprivate var isFbLogin: Bool = false
    
    private struct LinkText {
        static let serviceTerms = "利用規約"
        static let privacyPolicy = "プライバシーポリシー"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupDialog()
        setupFacebookBtn()
        setupLink()
        observeSignInBtn()
        observeSignUpBtn()
        observeSkipBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
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
    
    private func observeSkipBtn() {
        skipBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                self.skip()
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeSignUpBtn() {
        signUpBtn.rx.tap
            .asDriver()
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
    
    private func setupLink() {
        linkTextView.isUserInteractionEnabled = true
        linkTextView.isEditable = false
        linkTextView.isSelectable = true

        let text = "登録することによって、利用規約、プライバシーポリシーに同意します。"
        
        serviceTermsRange = createLinkRange(text: text, linkText: LinkText.serviceTerms)
        privacyPolicyRange = createLinkRange(text: text, linkText: LinkText.privacyPolicy)
        
        linkTextView.attributedText = createLinkText(text: text)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(WelcomeViewController.tapLink(tap:)))
        linkTextView.addGestureRecognizer(tap)
    }
    
    private func createLinkText(text: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        attributedString.addAttributes(
            [
                NSForegroundColorAttributeName: UIColor.linkTextColor(),
                NSParagraphStyleAttributeName: style
            ],
            range: NSMakeRange(0, text.characters.count))
        
        
        attributedString.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.activeColor(),
            range: serviceTermsRange)
        attributedString.addAttribute(
            NSUnderlineStyleAttributeName,
            value: NSUnderlineStyle.styleSingle.rawValue,
            range: serviceTermsRange)
        
        attributedString.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.activeColor(),
            range: privacyPolicyRange)
        attributedString.addAttribute(
            NSUnderlineStyleAttributeName,
            value: NSUnderlineStyle.styleSingle.rawValue,
            range: privacyPolicyRange)
        
        return attributedString
    }
    
    private func createLinkRange(text: String, linkText: String) -> NSRange {
        let link = text.range(of: linkText)
        let start = text.distance(from: text.startIndex, to: link!.lowerBound)
        return NSMakeRange(start, linkText.characters.count)
    }
    
    func tapLink(tap: UITapGestureRecognizer) {
        let location = tap.location(in: linkTextView)
        let textPosition = linkTextView.closestPosition(to: location)
        let selectedPosition = linkTextView.offset(from: linkTextView.beginningOfDocument, to: textPosition!)
        
        if NSLocationInRange(selectedPosition, serviceTermsRange) {
            toServiceTermsViewController()
        } else if NSLocationInRange(selectedPosition, privacyPolicyRange) {
            toPrivacyPolicyViewController()
        }
    }
    
    private func toServiceTermsViewController() {
        let to = ModalWebViewController.instantiate(title: LinkText.serviceTerms, url: AppConfig.serviceTermsURL)
        present(to as UIViewController, animated: true, completion: nil)
    }
    
    private func toPrivacyPolicyViewController() {
        let to = ModalWebViewController.instantiate(title: LinkText.privacyPolicy, url: AppConfig.privacyPolicyURL)
        present(to as UIViewController, animated: true, completion: nil)
    }
    
    private func skip() {
        RootViewController.instantiateForRoot()
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

extension WelcomeViewController: FBSDKLoginButtonDelegate {
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
