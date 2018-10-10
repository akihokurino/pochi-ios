//
//  MySitterProfileNavigationController.swift
//  pochi
//
//  Created by akiho on 2017/08/11.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class MySitterProfileNavigationController: UINavigationController {
    
    static func instantiate() -> MySitterProfileNavigationController {
        let vc = R.storyboard.profile.mySitterProfileNavigationController()!
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
