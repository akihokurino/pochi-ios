//
//  PhotoViewController.swift
//  pochi
//
//  Created by akiho on 2017/06/15.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoPagerViewController: UIViewController {
    
    static func instantiate(images: [Image], selectImage: Image) -> PhotoPagerViewController {
        let vc = R.storyboard.photoPager.photoPagerViewController()!
        vc.images = images
        vc.selectImage = selectImage
        return vc
    }
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    fileprivate var controllers: [PhotoViewController] = []
    private let disposeBag: DisposeBag = DisposeBag()
    fileprivate var images: [Image]!
    fileprivate var selectImage: Image!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupPager()
        observeCancelBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupPager() {
        controllers = []
        var firstVC: UIViewController!
        images.forEach {
            let vc = PhotoViewController.instantiate(image: $0)
            controllers.append(vc)
            
            if $0.id == self.selectImage.id {
                firstVC = vc
            }
        }
    
        let pageViewController = childViewControllers[0] as! UIPageViewController
        pageViewController.dataSource = self
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
    }
    
    private func observeCancelBtn() {
        cancelBtn.rx.tap
            .asDriver()
            .drive(onNext: {
                self.dismiss(animated: true, completion: nil)
            })
            .addDisposableTo(disposeBag)
    }
}

extension PhotoPagerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = controllers.index(of: viewController as! PhotoViewController), index > 0 else {
            return nil
        }
        
        return controllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = controllers.index(of: viewController as! PhotoViewController), index < controllers.count - 1 else {
            return nil
        }
        
        return controllers[index + 1]
    }
}
