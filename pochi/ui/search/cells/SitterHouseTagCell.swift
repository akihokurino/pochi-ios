//
//  SitterHouseTagCell.swift
//  pochi
//
//  Created by akiho on 2017/02/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import UIKit

class SitterHouseTagCell: UITableViewCell {
    
    static let HEIGHT: Int = 301
    static let IDENTITY: String = R.reuseIdentifier.sitterHouseTagCell.identifier
    static let NIB: UINib = R.nib.sitterHouseTagCell()

    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var middleStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = UITableViewCellSelectionStyle.none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(sitter: Sitter) {
        let stackList: [UIStackView] = [topStackView, middleStackView, bottomStackView]
        let tags: [[TagView?]] = setupTags(sitter: sitter)
        
        for i in 0..<3 {
            let stack = stackList[i]
            stack.subviews.forEach { $0.removeFromSuperview() }
            stack.distribution = UIStackViewDistribution.fillEqually
            for j in 0..<3 {
                guard let tagView = tags[i][j] else {
                    break
                }
                
                if j == 2 {
                    tagView.hideRightBorder()
                }
                
                stack.addArrangedSubview(tagView)
            }
        }
    }
    
    private func setupTags(sitter: Sitter) -> [[TagView?]] {
        var tags: [[TagView?]] = [[], [], []]
        
        tags[0] = [TagView?](repeating: nil, count: 3)
        tags[1] = [TagView?](repeating: nil, count: 3)
        tags[2] = [TagView?](repeating: nil, count: 3)
        
        tags[0][0] = TagView.generateSmallDogTag(sitter: sitter)
        tags[0][1] = TagView.generateMediumDogTag(sitter: sitter)
        tags[0][2] = TagView.generateLargeDogTag(sitter: sitter)
        tags[1][0] = TagView.generateHouseTag(sitter: sitter)
        tags[1][1] = TagView.generateSmokeTag(sitter: sitter)
        
        var optionTags: [TagView] = [
            TagView.generateKidsTag(sitter: sitter),
            TagView.generateEarlyMorningTag(sitter: sitter),
            TagView.generateLateNightTag(sitter: sitter)
        ].filter({ $0 != nil }) as! [TagView]
        
        for i in 0..<3 {
            for j in 0..<3 {
                if tags[i][j] == nil {
                    let tagView: TagView = !optionTags.isEmpty ? optionTags.removeFirst() : TagView.generateEmptyTag()
                    tags[i][j] = tagView
                }
            }
        }
        
        return tags
    }
}
