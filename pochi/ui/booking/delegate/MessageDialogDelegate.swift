//
//  MessageDialogDelegate.swift
//  pochi
//
//  Created by akiho on 2017/03/12.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MessageDialogDelegate: DialogDelegate {
    
    func showCancelDialog() -> Variable<Bool?> {
        let variable: Variable<Bool?> = Variable(nil)
        
        let alert: UIAlertController = UIAlertController(
            title: "",
            message: "選択してください",
            preferredStyle:  UIAlertControllerStyle.actionSheet)
        let doneAction: UIAlertAction = UIAlertAction(
            title: "予約をキャンセルする",
            style: UIAlertActionStyle.default,
            handler: { (action: UIAlertAction!) -> Void in
                variable.value = true
            })
        let cancelAction: UIAlertAction = UIAlertAction(
            title: "キャンセル",
            style: UIAlertActionStyle.cancel,
            handler: { (action: UIAlertAction!) -> Void in
                return variable.value = false
            })
        
        alert.addAction(doneAction)
        alert.addAction(cancelAction)

        container?.present(alert, animated: true, completion: nil)
        
        return variable
    }
    
    func showCancelConfirmForSitter() -> Variable<Bool?> {
        let variable: Variable<Bool?> = Variable(nil)
        
        let alert: UIAlertController = UIAlertController(
            title: "確認",
            message: "確定した予約をキャンセルすると1,000ポイントのペナルティが課されます。キャンセルしますか？",
            preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "はい",
            style: UIAlertActionStyle.default,
            handler: { (action: UIAlertAction!) -> Void in
                variable.value = true
        })
        let cancelAction: UIAlertAction = UIAlertAction(
            title: "いいえ",
            style: UIAlertActionStyle.cancel,
            handler: { (action: UIAlertAction!) -> Void in
                variable.value = false
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        container?.present(alert, animated: true, completion: nil)
        
        return variable
    }
    
    func showCancelConfirmForUser() -> Variable<Bool?> {
        let variable: Variable<Bool?> = Variable(nil)
        
        let alert: UIAlertController = UIAlertController(
            title: "確認",
            message: "確定した予約をキャンセルすると100%のキャンセル料が発生します。キャンセルしますか？",
            preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "はい",
            style: UIAlertActionStyle.default,
            handler: { (action: UIAlertAction!) -> Void in
                variable.value = true
        })
        let cancelAction: UIAlertAction = UIAlertAction(
            title: "いいえ",
            style: UIAlertActionStyle.cancel,
            handler: { (action: UIAlertAction!) -> Void in
                variable.value = false
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        container?.present(alert, animated: true, completion: nil)
        
        return variable
    }
}

