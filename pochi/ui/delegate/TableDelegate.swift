//
//  TableDelegate.swift
//  pochi
//
//  Created by akiho on 2017/03/10.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit

class TableDelegate {
    static let READ_MORE_CELL_HEIGHT = 48
    static let SECTION_HEIGHT = 48
    
    weak var tableView: UITableView?
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func generateSectionHeader(section: Int, title: String) -> UIView {
        return generateSectionHeader(
            section: section,
            title: title,
            height: TableDelegate.SECTION_HEIGHT,
            font: UIFont.systemFont(ofSize: 13),
            textColor: UIColor.linkTextColor())
    }
    
    func generateTitleSectionHeader(section: Int, title: String) -> UIView {
        return generateSectionHeader(
            section: section,
            title: title,
            height: TableDelegate.SECTION_HEIGHT,
            font: UIFont.systemFont(ofSize: 19),
            textColor: UIColor.cellTitleColor())
    }
    
    func generateSectionHeader(section: Int, title: String, height: Int) -> UIView {
        return generateSectionHeader(
            section: section,
            title: title,
            height: height,
            font: UIFont.systemFont(ofSize: 13),
            textColor: UIColor.linkTextColor())
    }
    
    func generateSectionHeader(section: Int, title: String, score: Double) -> UIView {
        let headerView = generateSectionHeader(section: section, title: title)
        
        let reviewScoreView = ReviewScoreView.instance()
        reviewScoreView.setup(score: score)
        reviewScoreView.frame = CGRect(
            x: UIScreen.main.bounds.size.width - reviewScoreView.frame.size.width - 16,
            y: 20,
            width: reviewScoreView.frame.size.width,
            height: reviewScoreView.frame.size.height
        )
        
        headerView.addSubview(reviewScoreView)
        
        return headerView
    }
    
    private func generateSectionHeader(section: Int, title: String, height: Int, font: UIFont, textColor: UIColor) -> UIView {
        let headerView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: Int(tableView?.bounds.size.width ?? 0),
            height: height
        ))
        headerView.backgroundColor = UIColor.backgroundColor()
        
        let titleView = UILabel(frame: CGRect(
            x: 16,
            y: height - 33,
            width: Int(tableView?.bounds.size.width ?? 0),
            height: 30
        ))
        titleView.text = title
        titleView.font = font
        titleView.textColor = textColor
        
        headerView.addSubview(titleView)
        headerView.addBottomBorder()
        
        return headerView
    }
    
    func generateMoreReadCell() -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.contentView.frame = CGRect(
            x: cell.frame.origin.x,
            y: cell.frame.origin.y,
            width: cell.frame.size.width,
            height: CGFloat(TableDelegate.READ_MORE_CELL_HEIGHT))
        cell.textLabel?.text = "もっと読む"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13.0)
        cell.textLabel?.textColor = UIColor.activeColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.textAlignment = NSTextAlignment.center
        cell.addBottomBorder(width: Int(UIScreen.main.bounds.size.width))
        
        return cell
    }
}
