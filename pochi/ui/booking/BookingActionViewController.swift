//
//  BookingActionViewController.swift
//  pochi
//
//  Created by akiho on 2017/10/18.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD
import OmiseSDK

class BookingActionViewController: UIViewController {
    
    static let DEFAULT_HEIGHT: CGFloat = 48
    
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet weak var detailContainer: UIView!

    fileprivate let disposeBag: DisposeBag = DisposeBag()
    private var detailBtnDisposable: Disposable?
    fileprivate var viewModel: BookingActionViewModel!
    fileprivate var detailView: BookingDetailViewProtocol!
    private var dialogDelegate: MessageDialogDelegate!
    
    fileprivate var messageVC: MessageViewController {
        return self.parent as! MessageViewController
    }
    
    func bind(booking: Booking) {
        if viewModel == nil {
            viewModel = BookingActionViewModel(booking: booking)
        } else {
            viewModel.sync(booking: booking)
        }
        
        setup(booking: booking)
        observeDetailBtn()
        
        viewModel.observeUserDogs.drive(onNext: { dogs in
            (self.detailView as? LeaveBookingDetailView)?.bind(booking: booking, dogs: dogs)
            (self.detailView as? KeepBookingDetailView)?.bind(booking: booking, dogs: dogs)
        }).addDisposableTo(disposeBag)
        
        viewModel.observeCoupon.drive(onNext: { coupon in
            (self.detailView as? LeaveBookingDetailView)?.bind(booking: booking, coupon: coupon)
        }).addDisposableTo(disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupDialog()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupDialog() {
        dialogDelegate = MessageDialogDelegate(container: self)
    }
    
    fileprivate func setup(booking: Booking) {
        detailContainer.subviews.forEach({ $0.removeFromSuperview() })
        
        if viewModel.isSitter {
            let view = KeepBookingDetailView.instance(booking: booking)
            observeAction(view: view)
            detailView = view
        } else {
            let view = LeaveBookingDetailView.instance(booking: booking)
            observeAction(view: view)
            detailView = view
        }
        
        detailContainer.addSubview(detailView as! UIView)
        detailContainer.alpha = 0.0
        messageVC.detailViewHeightConstraint.constant = BookingActionViewController.DEFAULT_HEIGHT
        
        viewModel.isOpen = false
        detailBtn.setTitle("詳細を見る▼", for: .normal)
    }
    
    private func observeAction(view: KeepBookingDetailView) {
        view.observeAction
            .asObservable()
            .filter({ _ in !self.viewModel.isRequesting })
            .flatMap({ action -> Observable<KeepBookingDetailView.Action> in
                switch action {
                case .accept:
                    SVProgressHUD.show(withStatus: "承認中...")
                    return self.viewModel.acceptBooking()
                        .do(onNext: { _ in
                            SVProgressHUD.showSuccess(withStatus: "承認に成功しました")
                        }, onError: { _ in
                            SVProgressHUD.showError(withStatus: "承認に失敗しました")
                        })
                        .map({ _ in action })
                        .catchErrorJustReturn(.none)
                case .refuse:
                    SVProgressHUD.show(withStatus: "拒否中...")
                    return self.viewModel.rejectBooking()
                        .do(onNext: { _ in
                            SVProgressHUD.showSuccess(withStatus: "拒否しました")
                        }, onError: { _ in
                            SVProgressHUD.showError(withStatus: "拒否に失敗しました")
                        })
                        .map({ _ in action })
                        .catchErrorJustReturn(.none)
                default:
                    return Observable.just(action)
                }
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { action in
                switch action {
                case .accept:
                    self.setup(booking: self.viewModel.booking)
                    self.messageVC.refresh()
                    self.messageVC.updateNavigationMenu(booking: self.viewModel.booking)
                case .refuse:
                    self.setup(booking: self.viewModel.booking)
                    self.messageVC.refresh()
                    self.messageVC.updateNavigationMenu(booking: self.viewModel.booking)
                case .showUserProfile:
                    self.toUserProfileViewController()
                default:
                    break
                }
            }, onError: { _ in
                
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeAction(view: LeaveBookingDetailView) {
        view.observeAction
            .asObservable()
            .filter({ _ in !self.viewModel.isRequesting })
            .flatMap({ action -> Observable<LeaveBookingDetailView.Action> in
                switch action {
                case .cancel:
                    SVProgressHUD.show(withStatus: "キャンセル中...")
                    return self.viewModel.cancelBooking()
                        .do(onNext: { _ in
                            SVProgressHUD.showSuccess(withStatus: "キャンセルに成功しました")
                        }, onError: { _ in
                            SVProgressHUD.showError(withStatus: "キャンセルに失敗しました")
                        })
                        .map({ _ in action })
                        .catchErrorJustReturn(.none)
                default:
                    return Observable.just(action)
                }
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { action in
                switch action {
                case .edit:
                    self.messageVC.performSegue(
                        withIdentifier: R.segue.messageViewController.fromMessageToEditRequest.identifier,
                        sender: nil)
                case .request:
                    OmiseDelegate(container: self, delegate: self).show(action: #selector(self.dismissCreditCardForm))
                case .cancel:
                    self.setup(booking: self.viewModel.booking)
                    self.messageVC.refresh()
                case .showSitterProfile:
                    self.toSitterProfileViewController()
                case .showMap:
                    self.openMap()
                default:
                    break
                }
            }, onError: { _ in
                
            })
            .addDisposableTo(disposeBag)
    }
    
    private func observeDetailBtn() {
        detailBtnDisposable?.dispose()
        detailBtnDisposable = detailBtn.rx.tap.asDriver()
            .drive(onNext: {
                if self.viewModel.isOpen {
                    self.closeDetail()
                    self.detailBtn.setTitle("詳細を見る▼", for: .normal)
                } else {
                    self.openDetail()
                    self.detailBtn.setTitle("閉じる▲", for: .normal)
                }
                
                self.viewModel.isOpen = !self.viewModel.isOpen
            })
    }
    
    private func openDetail() {
        detailContainer.alpha = 0.0
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.messageVC.detailViewHeightConstraint.constant = self.detailView.height + BookingActionViewController.DEFAULT_HEIGHT
            },
            completion: { _ in
                self.detailContainer.alpha = 1.0
                self.messageVC.detailViewHeightConstraint.constant = self.detailView.height + BookingActionViewController.DEFAULT_HEIGHT
            }
        )
    }
    
    private func closeDetail() {
        detailContainer.alpha = 0.0
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.messageVC.detailViewHeightConstraint.constant = BookingActionViewController.DEFAULT_HEIGHT
            },
            completion: { _ in
                self.detailContainer.alpha = 0.0
                self.messageVC.detailViewHeightConstraint.constant = BookingActionViewController.DEFAULT_HEIGHT
            }
        )
    }
    
    private func toSitterProfileViewController() {
        if let sitter = viewModel.sitter {
            let to = SitterProfileViewController.instantiate(sitter: sitter)
            present(to as UIViewController, animated: true, completion: nil)
        }
    }
    
    private func toUserProfileViewController() {
        if let user = viewModel.user {
            let to = UserProfileNavigationController.instantiate(user: user)
            present(to, animated: true, completion: nil)
        }
    }
    
    private func openMap() {
        guard let address = viewModel.sitter?.address else {
            return
        }
        
        dialogDelegate.showMapDialog().asDriver()
            .drive(onNext: { action in
                switch action {
                case .Apple:
                    MapDelegate.openAppleMap(latitude: address.latitude, longitude: address.longitude)
                case .Google:
                    MapDelegate.openGoogleMap(latitude: address.latitude, longitude: address.longitude)
                default:
                    break
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    @objc func dismissCreditCardForm() {
        dismiss(animated: true, completion: nil)
    }
    
    func observeMenuAction(menuBtn: UIBarButtonItem) {
        menuBtn.rx.tap.filter({ !self.viewModel.isRequesting })
            .flatMap({ _ -> Observable<Bool?> in
                return self.dialogDelegate.showCancelDialog().asObservable()
            })
            .filter({ $0 != nil})
            .flatMap({ bool -> Observable<Bool?> in
                if bool! {
                    if self.viewModel.isSitter {
                        return self.dialogDelegate.showCancelConfirmForSitter().asObservable()
                    } else {
                        return self.dialogDelegate.showCancelConfirmForUser().asObservable()
                    }
                } else {
                    return Observable.just(nil)
                }
            })
            .filter({ $0 != nil})
            .flatMap({ bool -> Observable<Bool?> in
                if bool! {
                    SVProgressHUD.show(withStatus: "キャンセル中...")
                    return self.viewModel.cancelBooking()
                        .map({ _ in true })
                        .catchErrorJustReturn(false)
                } else {
                    return Observable.just(nil)
                }
            })
            .filter({ $0 != nil})
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                if result! {
                    SVProgressHUD.showSuccess(withStatus: "キャンセルに成功しました")
                    self.setup(booking: self.viewModel.booking)
                    self.messageVC.refresh()
                } else {
                    SVProgressHUD.showSuccess(withStatus: "キャンセルに失敗しました")
                }
            })
            .addDisposableTo(disposeBag)
    }
}

extension BookingActionViewController: CreditCardFormDelegate {
    func creditCardForm(_ controller: CreditCardFormController, didSucceedWithToken token: OmiseToken) {
        guard let tokenId = token.tokenId else {
            SVProgressHUD.showError(withStatus: "クレジットカードの登録に失敗しました")
            return
        }
        
        dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SVProgressHUD.show(withStatus: "リクエスト中...")
            
            self.viewModel.requestBooking(cardToken: tokenId)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { result in
                    SVProgressHUD.showSuccess(withStatus: "リクエストに成功しました")
                    self.setup(booking: self.viewModel.booking)
                    self.messageVC.refresh()
                }, onError: { _ in
                    SVProgressHUD.showError(withStatus: "リクエストに失敗しました")
                })
                .addDisposableTo(self.disposeBag)
        }
    }
    
    func creditCardForm(_ controller: CreditCardFormController, didFailWithError error: Error) {
        SVProgressHUD.showError(withStatus: "クレジットカードの登録に失敗しました")
    }
}
