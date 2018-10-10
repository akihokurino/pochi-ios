//
//  PhotoPickerDelegate.swift
//  pochi
//
//  Created by akiho on 2017/03/18.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit

class PhotoPickerDelegate<T> where T:UIViewController, T:UIImagePickerControllerDelegate, T:UINavigationControllerDelegate {
    private weak var container: T?
    
    init(container: T)  {
        self.container = container
    }
    
    func selectLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = container
            container?.present(picker, animated: true, completion: nil)
        }
    }
    
    func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let picker = UIImagePickerController()
            picker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            picker.delegate = container
            picker.sourceType = UIImagePickerControllerSourceType.camera
            container?.present(picker, animated: true, completion: nil)
        }
    }
}
