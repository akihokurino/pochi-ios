//
//  PhotoViewController.swift
//  pochi
//
//  Created by akiho on 2017/06/15.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    static func instantiate(image: Image) -> PhotoViewController {
        let vc = R.storyboard.photoPager.photoViewController()!
        vc.image = image
        return vc
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    fileprivate var image: Image!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.load(url: URL(string: image.image)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
