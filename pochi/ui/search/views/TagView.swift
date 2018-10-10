//
//  TagView.swift
//  pochi
//
//  Created by akiho on 2017/02/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class TagView: UIView {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rightBorderView: UIView!
    
    class func instance() -> TagView {
        let view = R.nib.tagView.firstView(owner: nil, options: nil)!
        
        view.frame = CGRect(
            x: 0,
            y: 0,
            width: 120,
            height: 100)
        
        return view
    }
    
    static func generateSmallDogTag(sitter: Sitter) -> TagView {
        let tagView: TagView = instance()
        
        if let _ = sitter.acceptableDogSizes.first(where: { $0 == Sitter.DogSizeType.small }) {
            tagView.setup(name: "小型犬：OK", image: R.image.about_house_1()!)
        } else {
            tagView.setup(name: "小型犬：NG", image: R.image.about_house_4()!)
        }
        
        return tagView
    }
    
    static func generateMediumDogTag(sitter: Sitter) -> TagView {
        let tagView: TagView = instance()
        
        if let _ = sitter.acceptableDogSizes.first(where: { $0 == Sitter.DogSizeType.medium }) {
            tagView.setup(name: "中型犬：OK", image: R.image.about_house_2()!)
        } else {
            tagView.setup(name: "中型犬：NG", image: R.image.about_house_5()!)
        }
        
        return tagView
    }
    
    static func generateLargeDogTag(sitter: Sitter) -> TagView {
        let tagView: TagView = instance()
        
        if let _ = sitter.acceptableDogSizes.first(where: { $0 == Sitter.DogSizeType.large }) {
            tagView.setup(name: "大型犬：OK", image: R.image.about_house_3()!)
        } else {
            tagView.setup(name: "大型犬：NG", image: R.image.about_house_6()!)
        }
        
        return tagView
    }
    
    static func generateHouseTag(sitter: Sitter) -> TagView {
        let tagView: TagView = instance()
        
        switch sitter.houseType {
        case .apartment:
            tagView.setup(name: "マンション", image: R.image.about_house_8()!)
        case .isolated:
            tagView.setup(name: "一軒家", image: R.image.about_house_7()!)
        }
        
        return tagView
    }
    
    static func generateSmokeTag(sitter: Sitter) -> TagView {
        let tagView: TagView = instance()
        
        switch sitter.smokingPolicy {
        case .smoking:
            tagView.setup(name: "喫煙の家", image: R.image.about_house_10()!)
        case .nonSmoking:
            tagView.setup(name: "禁煙の家", image: R.image.about_house_9()!)
        }
        
        return tagView
    }
    
    static func generateKidsTag(sitter: Sitter) -> TagView? {
        let tagView: TagView = instance()
        
        guard !sitter.kidsTypes.isEmpty else {
            return nil
        }
        
        switch sitter.kidsTypes[0] {
        case .infant:
            tagView.setup(name: "赤ちゃんがいます", image: R.image.about_house_12()!)
        case .schoolchild:
            tagView.setup(name: "小学生がいます", image: R.image.about_house_11()!)
        }
        
        return tagView
    }

    static func generateEarlyMorningTag(sitter: Sitter) -> TagView? {
        let tagView: TagView = instance()
        
        if let _ = sitter.options.first(where: { $0 == Sitter.Option.earlyMorning }) {
            tagView.setup(name: "朝早く対応可能", image: R.image.about_house_14()!)
        } else {
            return nil
        }
        
        return tagView
    }

    static func generateLateNightTag(sitter: Sitter) -> TagView? {
        let tagView: TagView = instance()
        
        if let _ = sitter.options.first(where: { $0 == Sitter.Option.lateNight }) {
            tagView.setup(name: "夜遅く対応可能", image: R.image.about_house_15()!)
        } else {
            return nil
        }
        
        return tagView
    }
    
    static func generateEmptyTag() -> TagView {
        let tagView: TagView = instance()
        tagView.setup(name: "", image: nil)
        return tagView
    }

    func setup(name: String, image: UIImage?) {
        nameLabel.text = name
        iconView.image = image
    }
    
    func hideRightBorder() {
        rightBorderView.isHidden = true
    }
}
