//
//  LeaveBookingDetailView.swift
//  pochi
//
//  Created by akiho on 2017/10/18.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LeaveBookingDetailView: UIView, BookingDetailViewProtocol {
    
    class func instance(booking: Booking) -> LeaveBookingDetailView {
        let view = R.nib.leaveBookingDetailView.firstView(owner: nil, options: nil)!
    
        switch booking.status {
        case .prerequest:
            view.detailType = .showRequestBtn
        case .request:
            view.detailType = .showCancelBtn
        case .confirm: fallthrough
        case .stay:
            view.detailType = .showAccepted
        case .cancel:
            view.detailType = .showCanceled
        case .refuse:
            view.detailType = .showRefuse
        default:
            view.detailType = .none
        }
        
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: view.height)
        
        view.linkBtn.rx.tap.asDriver()
            .drive(onNext: {
                view.action.value = .showSitterProfile
            })
            .addDisposableTo(view.disposeBag)
        
        view.createActionView()
        
        if booking.status == .cancel {
            view.reset()
        } else {
            view.bind(booking: booking)
        }
        
        return view
    }
    
    enum DetailType {
        case none
        case showRequestBtn
        case showCancelBtn
        case showAccepted
        case showCanceled
        case showRefuse
    }
    
    enum Action {
        case none
        case showSitterProfile
        case request
        case cancel
        case edit
        case showMap
    }

    @IBOutlet weak var dogLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var actionContainer: UIView!
    @IBOutlet weak var linkBtn: UIButton!
    
    private var detailType: DetailType = .none
    private let action: Variable<Action> = Variable(.none)
    private var requestBtn: UIButton?
    private let disposeBag: DisposeBag = DisposeBag()
    
    var height: CGFloat {
        switch detailType {
        case .none: fallthrough
        case .showRequestBtn: fallthrough
        case .showCancelBtn: fallthrough
        case .showCanceled: fallthrough
        case .showAccepted: fallthrough
        case .showRefuse:
            return 350
        }
    }
    
    var observeAction: Driver<Action> {
        return action.asDriver()
    }
    
    private func bind(booking: Booking) {
        if booking.startDate != nil && booking.endDate != nil {
            dateLabel.text = "\(booking.startDate!) ~ \(booking.endDate!)"
        }
        
        priceLabel.text = "\(booking.totalPrice)円（税込）"
        pointLabel.text = "\(booking.usePoint)ポイント"
        totalPriceLabel.text = "\(booking.totalChargePrice)円（税込）"
        
        if booking.isValidForRequest {
            requestBtn?.isEnabled = true
            requestBtn?.backgroundColor = UIColor.activeColor()
        }
    }
    
    func bind(booking: Booking, dogs: [Dog]) {
        guard booking.status != .cancel else {
            dogLabel.text = "ー"
            return
        }
        
        dogLabel.text = booking.dogIds.map({ id -> String in
            dogs.first(where: { dog -> Bool in
                return dog.id == id
            })?.name ?? ""
        }).filter({ !$0.isEmpty }).joined(separator: ",")
    }
    
    func bind(booking: Booking, coupon: Coupon) {
        guard booking.status != .cancel else {
            couponLabel.text = "ー"
            return
        }
        
        couponLabel.text = "\(coupon.discountPrice)円割引きクーポンを使用"
    }
    
    private func reset() {
        dogLabel.text = "ー"
        dateLabel.text = "ー"
        priceLabel.text = "ー"
        pointLabel.text = "ー"
        couponLabel.text = "ー"
        totalPriceLabel.text = "ー"
    }
    
    private func createActionView() {
        actionContainer.subviews.forEach({ $0.removeFromSuperview() })
        switch detailType {
        case .showRequestBtn:
            createRequestBtn()
        case .showCancelBtn:
            createCancelBtn()
        case .showAccepted:
            createMapBtn()
        case .showCanceled:
            createEmptyView(message: "キャンセルされました")
        case .showRefuse:
            createEmptyView(message: "拒否されました")
        default:
            createEmptyView(message: "操作できません")
        }
    }
    
    private func createRequestBtn() {
        let editBtn = UIButton(frame: CGRect(
            x: 16,
            y: 0,
            width: actionContainer.frame.size.width / 2 - 24,
            height: actionContainer.frame.size.height))
        editBtn.setTitle("内容を変更", for: .normal)
        editBtn.setTitleColor(UIColor.activeColor(), for: .normal)
        editBtn.backgroundColor = UIColor.white
        editBtn.layer.masksToBounds = true
        editBtn.layer.cornerRadius = 4.0
        editBtn.layer.borderColor = UIColor.activeColor().cgColor
        editBtn.layer.borderWidth = 1.0
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        editBtn.rx.tap.asDriver()
            .drive(onNext: {
                self.action.value = .edit
            })
            .addDisposableTo(disposeBag)
        actionContainer.addSubview(editBtn)
        
        requestBtn = UIButton(frame: CGRect(
            x: actionContainer.frame.size.width / 2 + 8,
            y: 0,
            width: actionContainer.frame.size.width / 2 - 24,
            height: actionContainer.frame.size.height))
        requestBtn!.setTitle("リクエスト", for: .normal)
        requestBtn!.setTitleColor(UIColor.white, for: .normal)
        requestBtn!.backgroundColor = UIColor.inActiveColor()
        requestBtn!.isEnabled = false
        requestBtn!.layer.masksToBounds = true
        requestBtn!.layer.cornerRadius = 4.0
        requestBtn!.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        requestBtn!.rx.tap.asDriver()
            .drive(onNext: {
                self.action.value = .request
            })
            .addDisposableTo(disposeBag)
        actionContainer.addSubview(requestBtn!)
    }
    
    private func createCancelBtn() {
        let cancelBtn = UIButton(frame: CGRect(
            x: 16,
            y: 0,
            width: actionContainer.frame.size.width - 32,
            height: actionContainer.frame.size.height))
        cancelBtn.setTitle("リクエストを取り消す", for: .normal)
        cancelBtn.setTitleColor(UIColor.activeColor(), for: .normal)
        cancelBtn.backgroundColor = UIColor.white
        cancelBtn.layer.masksToBounds = true
        cancelBtn.layer.cornerRadius = 4.0
        cancelBtn.layer.borderColor = UIColor.activeColor().cgColor
        cancelBtn.layer.borderWidth = 1.0
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        cancelBtn.rx.tap.asDriver()
            .drive(onNext: {
                self.action.value = .cancel
            })
            .addDisposableTo(disposeBag)
        actionContainer.addSubview(cancelBtn)
    }
    
    private func createMapBtn() {
        let label = UILabel(frame: CGRect(
            x: 16,
            y: 7,
            width: 80,
            height: 16))
        label.text = "ホストの住所"
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor.labelColor()
        actionContainer.addSubview(label)
        
        let mapBtn = UIButton(frame: CGRect(
            x: actionContainer.frame.size.width - 120 - 16,
            y: 0,
            width: 120,
            height: actionContainer.frame.size.height))
        mapBtn.setTitle("住所をマップで確認", for: .normal)
        mapBtn.setTitleColor(UIColor.activeColor(), for: .normal)
        mapBtn.backgroundColor = UIColor.white
        mapBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        mapBtn.rx.tap.asDriver()
            .drive(onNext: {
                self.action.value = .showMap
            })
            .addDisposableTo(disposeBag)
        actionContainer.addSubview(mapBtn)
    }
    
    private func createEmptyView(message: String) {
        let label = UILabel(frame: CGRect(
            x: 16,
            y: 14,
            width: actionContainer.frame.size.width - 32,
            height: 16))
        label.text = message
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor.labelColor()
        actionContainer.addSubview(label)
        
        linkBtn.isHidden = true
    }
}
