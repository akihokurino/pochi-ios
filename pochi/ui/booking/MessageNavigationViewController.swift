//
//  MessageNavigationViewController.swift
//  pochi
//
//  Created by akiho on 2017/10/21.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class MessageNavigationViewController: UINavigationController {
    
    static func instantiate(booking: Booking) -> MessageNavigationViewController {
        let vc = R.storyboard.message.messageNavigationViewController()!
        (vc.viewControllers[0] as! MessageViewController).bind(booking: booking)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
