//
//  ReviewPromotionViewController.swift
//  pochi
//
//  Created by akiho on 2017/06/10.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ReviewPromotionViewController: UIViewController {
    
    static func instantiate() -> ReviewPromotionViewController {
        let vc = R.storyboard.promotion.reviewPromotionViewController()!
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear

        setupBackgroundImageView()
        observeCloseBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.backgroundColor = UIColor.modalBackgroundColor()
    }
    
    private func setupBackgroundImageView() {
        let effect = UIBlurEffect(style: .extraLight)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.backgroundImageView.frame.width,
                                  height: self.backgroundImageView.frame.height)
        effectView.layer.masksToBounds = true
        backgroundImageView.addSubview(effectView)
    }
    
    private func observeCloseBtn() {
        closeBtn.rx.tap.asDriver()
            .drive(onNext: {
                self.dismiss(animated: false, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }
}
