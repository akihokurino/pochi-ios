//
//  KeepBookingNavigationController.swift
//  pochi
//
//  Created by akiho on 2017/07/26.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class KeepBookingNavigationController: UINavigationController {
    
    static func instantiate() -> KeepBookingNavigationController {
        let vc = R.storyboard.keepBooking.keepBookingNavigationController()!
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
