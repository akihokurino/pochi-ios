//
//  DialogDelegate.swift
//  pochi
//
//  Created by akiho on 2017/03/12.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class DialogDelegate {
    weak var container: UIViewController?
    
    init(container: UIViewController) {
        self.container = container
    }
    
    enum MapAction {
        case None
        case Apple
        case Google
    }
    
    func showMapDialog() -> Variable<MapAction> {
        let variable = Variable(MapAction.None)
        
        let alert: UIAlertController = UIAlertController(
            title: "",
            message: "選択してください",
            preferredStyle:  UIAlertControllerStyle.actionSheet)
        let googleMapAction: UIAlertAction = UIAlertAction(
            title: "Googleマップで開く",
            style: UIAlertActionStyle.default,
            handler: { (action: UIAlertAction!) -> Void in
                variable.value = MapAction.Google
            })
        let appleMapAction: UIAlertAction = UIAlertAction(
            title: "Appleマップで開く",
            style: UIAlertActionStyle.default,
            handler: { (action: UIAlertAction!) -> Void in
                variable.value = MapAction.Apple
            })
        let cancelAction: UIAlertAction = UIAlertAction(
            title: "キャンセル",
            style: UIAlertActionStyle.cancel,
            handler: { (action: UIAlertAction!) -> Void in
                variable.value = MapAction.None
            })
        
        alert.addAction(googleMapAction)
        alert.addAction(appleMapAction)
        alert.addAction(cancelAction)
        
        container?.present(alert, animated: true, completion: nil)
        
        return variable
    }
    
    enum UploadMenu {
        case SelectLibrary
        case TakePicture
        case Cancel
    }
    
    func showUploadMenuDialog() -> Variable<UploadMenu> {
        let variable = Variable(UploadMenu.Cancel)
        
        let alert: UIAlertController = UIAlertController(
            title: "",
            message: "選択してください",
            preferredStyle:  UIAlertControllerStyle.actionSheet)
        let defaultAction1: UIAlertAction = UIAlertAction(
            title: "ライブラリから選択",
            style: UIAlertActionStyle.default,
            handler: { (action: UIAlertAction!) -> Void in
                variable.value = UploadMenu.SelectLibrary
            })
        let defaultAction2: UIAlertAction = UIAlertAction(
            title: "写真をとる",
            style: UIAlertActionStyle.default,
            handler: { (action: UIAlertAction!) -> Void in
                variable.value = UploadMenu.TakePicture
            })
        let cancelAction: UIAlertAction = UIAlertAction(
            title: "キャンセル",
            style: UIAlertActionStyle.cancel,
            handler: { (action: UIAlertAction!) -> Void in
                variable.value = UploadMenu.Cancel
            })
        
        alert.addAction(defaultAction1)
        alert.addAction(defaultAction2)
        alert.addAction(cancelAction)
        
        container?.present(alert, animated: true, completion: nil)
        
        return variable
    }
    
    func simpleAlert(title: String) {
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        container?.present(alert, animated: true, completion: nil)
    }
    
    enum LoginMenu {
        case None
        case Cancel
        case Facebook
        case Email
    }
    
    func showLoginMenuDialog() -> Variable<LoginMenu> {
        let variable = Variable(LoginMenu.None)
        
        let alert: UIAlertController = UIAlertController(
            title: "",
            message: "選択してください",
            preferredStyle:  UIAlertControllerStyle.actionSheet)
        let facebookAction: UIAlertAction = UIAlertAction(
            title: "Facebookでログイン",
            style: UIAlertActionStyle.default,
            handler: { (action: UIAlertAction!) -> Void in
                variable.value = LoginMenu.Facebook
        })
        let emailAction: UIAlertAction = UIAlertAction(
            title: "メールアドレスでログイン",
            style: UIAlertActionStyle.default,
            handler: { (action: UIAlertAction!) -> Void in
                variable.value = LoginMenu.Email
        })
        let cancelAction: UIAlertAction = UIAlertAction(
            title: "キャンセル",
            style: UIAlertActionStyle.cancel,
            handler: { (action: UIAlertAction!) -> Void in
                return variable.value = LoginMenu.Cancel
        })
        
        alert.addAction(facebookAction)
        alert.addAction(emailAction)
        alert.addAction(cancelAction)
        
        container?.present(alert, animated: true, completion: nil)
        
        return variable
    }
}
