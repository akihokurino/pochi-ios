//
//  ReturnPointTableDelegate.swift
//  pochi
//
//  Created by Akiho Kurino on 2017/08/04.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit

class ReturnPointTableDelegate: TableDelegate {
    func generateHeaderView(point: Int64) -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
        headerView.backgroundColor = UIColor.backgroundColor()
        let label = UILabel(frame: CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: 42))
        label.numberOfLines = 2
        label.textColor = UIColor.sectionTitleColor()
        label.font = UIFont.systemFont(ofSize: 13.0)
        label.text = "振込申請が可能なポイント：\(point)ポイント\n（1ポイント=1円換算）"
        label.textAlignment = .center
        headerView.addSubview(label)
        return headerView
    }
}
