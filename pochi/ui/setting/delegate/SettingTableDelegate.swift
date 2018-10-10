//
//  SimpleTableDelegate.swift
//  pochi
//
//  Created by akiho on 2017/01/07.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit

class SettingTableDelegate: TableDelegate {
    static let CELL_HEIGHT: Int = 48
    
    func generateSectionHeader(dataSource: [Section], section: Int) -> UIView {
        return generateSectionHeader(
            section: section,
            title: dataSource[section].getTitle(),
            height: dataSource[section].getSectionHeight())
    }
    
    func generateCell(dataSource: [Section], indexPath: IndexPath) -> UITableViewCell {
        
        let item = dataSource[indexPath.section].getItems()[indexPath.row]
        
        var cell: UITableViewCell!
        if item.type == .Version {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
            cell.detailTextLabel?.text = AppConfig.version
            cell.detailTextLabel?.textColor = UIColor.linkTextColor()
        } else {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        
        cell.textLabel?.text = item.label
        cell.textLabel?.font = UIFont.systemFont(ofSize: 13.0)
        cell.textLabel?.textColor = item.labelColor
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if item.hasArrow {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        if item.isCenter {
            cell.textLabel?.textAlignment = NSTextAlignment.center
        }
        
        cell.addBottomBorder(width: Int(UIScreen.main.bounds.width), y: SettingTableDelegate.CELL_HEIGHT - 1)
        
        return cell
    }
    
    func generateCell(title: String) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = title
         cell.textLabel?.font = UIFont.systemFont(ofSize: 13.0)
        cell.textLabel?.textColor = UIColor.mainTextColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.addBottomBorder(width: Int(UIScreen.main.bounds.width), y: SettingTableDelegate.CELL_HEIGHT - 1)
        
        return cell
    }
}
