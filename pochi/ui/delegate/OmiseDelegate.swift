//
//  OmiseDelegate.swift
//  pochi
//
//  Created by akiho on 2017/08/09.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import OmiseSDK

class OmiseDelegate {
    private let publicKey = "pkey_test_59f7nfpjzyb65xigde9"
    private weak var container: UIViewController?
    private weak var delegate: CreditCardFormDelegate?
    
    init(container: UIViewController, delegate: CreditCardFormDelegate) {
        self.container = container
        self.delegate = delegate
    }
    
    func show(action: Selector?) {
        let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: action)
        
        let creditCardView = CreditCardFormController.makeCreditCardForm(withPublicKey: publicKey)
        creditCardView.delegate = delegate
        creditCardView.handleErrors = true
        creditCardView.navigationItem.rightBarButtonItem = closeButton
        
        let navigation = UINavigationController(rootViewController: creditCardView)
        self.container?.present(navigation, animated: true, completion: nil)
    }
}
