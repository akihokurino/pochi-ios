//
//  KeepBookingDetailView.swift
//  pochi
//
//  Created by akiho on 2017/10/19.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class KeepBookingDetailView: UIView, BookingDetailViewProtocol {
    
    class func instance(booking: Booking) -> KeepBookingDetailView {
        let view = R.nib.keepBookingDetailView.firstView(owner: nil, options: nil)!
        
        switch booking.status {
        case .prerequest:
            view.detailType = .none
        case .request:
            view.detailType = .showAcceptBtn
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
                view.action.value = .showUserProfile
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
        case showAcceptBtn
        case showAccepted
        case showCanceled
        case showRefuse
    }
    
    enum Action {
        case none
        case showUserProfile
        case accept
        case refuse
    }

    @IBOutlet weak var dogLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxRewardPointLabel: UILabel!
    @IBOutlet weak var actionContainer: UIView!
    @IBOutlet weak var linkBtn: UIButton!
    
    private var detailType: DetailType = .none
    private let action: Variable<Action> = Variable(.none)
    private let disposeBag: DisposeBag = DisposeBag()
    
    var height: CGFloat {
        switch detailType {
        case .none: fallthrough
        case .showAcceptBtn: fallthrough
        case .showCanceled: fallthrough
        case .showAccepted: fallthrough
        case .showRefuse:
            return 220
        }
    }
    
    var observeAction: Driver<Action> {
        return action.asDriver()
    }
    
    private func bind(booking: Booking) {
        if booking.startDate != nil && booking.endDate != nil {
            dateLabel.text = "\(booking.startDate!) ~ \(booking.endDate!)"
        }
        
        maxRewardPointLabel.text = "\(booking.maxRewardPoint)ポイント"
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
    
    private func reset() {
        dogLabel.text = "ー"
        dateLabel.text = "ー"
        maxRewardPointLabel.text = "ー"
    }
    
    private func createActionView() {
        actionContainer.subviews.forEach({ $0.removeFromSuperview() })
        switch detailType {
        case .showAcceptBtn:
            createAcceptBtn()
        case .showAccepted:
            createAcceptedView()
        case .showCanceled:
            createEmptyView(message: "キャンセルされました")
        case .showRefuse:
            createEmptyView(message: "拒否しました")
        default:
            createEmptyView(message: "まだリクエストの詳細はありません")
        }
    }
    
    private func createAcceptBtn() {
        let refuseBtn = UIButton(frame: CGRect(
            x: 16,
            y: 0,
            width: actionContainer.frame.size.width / 2 - 24,
            height: actionContainer.frame.size.height))
        refuseBtn.setTitle("却下", for: .normal)
        refuseBtn.setTitleColor(UIColor.activeColor(), for: .normal)
        refuseBtn.backgroundColor = UIColor.white
        refuseBtn.layer.masksToBounds = true
        refuseBtn.layer.cornerRadius = 4.0
        refuseBtn.layer.borderColor = UIColor.activeColor().cgColor
        refuseBtn.layer.borderWidth = 1.0
        refuseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        refuseBtn.rx.tap.asDriver()
            .drive(onNext: {
                self.action.value = .refuse
            })
            .addDisposableTo(disposeBag)
        actionContainer.addSubview(refuseBtn)
        
        let acceptBtn = UIButton(frame: CGRect(
            x: actionContainer.frame.size.width / 2 + 8,
            y: 0,
            width: actionContainer.frame.size.width / 2 - 24,
            height: actionContainer.frame.size.height))
        acceptBtn.setTitle("リクエストを承諾", for: .normal)
        acceptBtn.setTitleColor(UIColor.white, for: .normal)
        acceptBtn.backgroundColor = UIColor.activeColor()
        acceptBtn.layer.masksToBounds = true
        acceptBtn.layer.cornerRadius = 4.0
        acceptBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        acceptBtn.rx.tap.asDriver()
            .drive(onNext: {
                self.action.value = .accept
            })
            .addDisposableTo(disposeBag)
        actionContainer.addSubview(acceptBtn)
    }
    
    private func createAcceptedView() {
        let label = UILabel(frame: CGRect(
            x: 16,
            y: 14,
            width: actionContainer.frame.size.width - 32,
            height: 16))
        label.text = "承認済みです"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor.labelColor()
        actionContainer.addSubview(label)
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
