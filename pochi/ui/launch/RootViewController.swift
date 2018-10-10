//
//  RootViewController.swift
//  pochi
//
//  Created by akiho on 2017/07/26.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {
    
    static func instantiateForRoot() {
        let root = R.storyboard.main.rootViewController()!
        UIApplication.shared.keyWindow?.rootViewController = root
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setup() {
        self.delegate = self
        UITabBar.appearance().tintColor = UIColor.activeColor()
        
        let tabBarItem1 = UITabBarItem(title: "探す",
                                       image: R.image.ic_tab_search(),
                                       selectedImage:R.image.ic_tab_search_active())
        let tabBarItem2 = UITabBarItem(title: "ホストとやりとり",
                                       image: R.image.ic_tab_leave(),
                                       selectedImage: R.image.ic_tab_leave_active())
        let tabBarItem3 = UITabBarItem(title: "受け入れ",
                                       image: R.image.ic_tab_keep(),
                                       selectedImage: R.image.ic_tab_keep_active())
        let tabBarItem4 = UITabBarItem(title: "タスク",
                                       image: R.image.ic_tab_task(),
                                       selectedImage: R.image.ic_tab_task_active())
        let tabBarItem5 = UITabBarItem(title: "その他",
                                       image: R.image.ic_tab_others(),
                                       selectedImage: R.image.ic_tab_others_active())
        
        var viewControllers: [UIViewController] = []
        
        let searchNavigationController = SearchNavigationController.instantiate()
        searchNavigationController.tabBarItem = tabBarItem1
        viewControllers.append(searchNavigationController)
        
        let leaveBookingNavigationController = LeaveBookingNavigationController.instantiate()
        leaveBookingNavigationController.tabBarItem = tabBarItem2
        viewControllers.append(leaveBookingNavigationController)
        
        let keepBookingNavigationController = KeepBookingNavigationController.instantiate()
        keepBookingNavigationController.tabBarItem = tabBarItem3
        viewControllers.append(keepBookingNavigationController)
        
        let taskNavigationController = TaskNavigationController.instantiate()
        taskNavigationController.tabBarItem = tabBarItem4
        viewControllers.append(taskNavigationController)
        
        let settingNavigationController = SettingNavigationController.instantiate()
        settingNavigationController.tabBarItem = tabBarItem5
        viewControllers.append(settingNavigationController)
        
        setViewControllers(viewControllers, animated: false)
    }
    
    fileprivate func showSignUpPromotion() {
        let to = SignUpPromotionViewController.instantiate()
        self.present(to as UIViewController, animated: false, completion: nil)
    }
}

extension RootViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if AppUserStore.shared.restore() != nil {
            return true
        }
        
        switch viewController {
        case is LeaveBookingNavigationController:
            showSignUpPromotion()
            return false
        case is KeepBookingNavigationController:
            showSignUpPromotion()
            return false
        case is TaskNavigationController:
            showSignUpPromotion()
            return false
        default:
            return true
        }
    }
}
