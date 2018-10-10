//
//  ReportTaskDataSource.swift
//  pochi
//
//  Created by akiho on 2017/05/28.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ReportTaskDataSource: NSObject, UITableViewDataSource {
    fileprivate enum TableSection: Int, EnumEnumerable {
        case upload
        case comment
    }
    
    enum Action {
        case none
        case upload
    }
    
    private let tableDelegate: TableDelegate
    private let tableView: UITableView
    fileprivate let action: Variable<Action> = Variable(.none)
    private weak var delegate: UITextViewDelegate?
    private var currentUploadImage: UIImage?
    
    var observeAction: Driver<Action> {
        return action.asDriver()
    }
    
    init(tableView: UITableView, delegate: UITextViewDelegate) {
        self.tableView = tableView
        self.delegate = delegate
        self.tableDelegate = TableDelegate(tableView: tableView)
        
        self.tableView.register(UploadPhotoCell.NIB, forCellReuseIdentifier: UploadPhotoCell.IDENTITY)
        self.tableView.register(TextViewWithoutLabelCell.NIB, forCellReuseIdentifier: TextViewWithoutLabelCell.IDENTITY)
        
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.cases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSection(rawValue: section)! {
        case .upload:
            return 1
        case .comment:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch TableSection(rawValue: section)! {
        case .upload:
            return tableDelegate.generateSectionHeader(section: section, title: "写真を添付")
        case .comment:
            return tableDelegate.generateSectionHeader(section: section, title: "コメント")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableSection(rawValue: indexPath.section)! {
        case .upload:
            let cell: UploadPhotoCell = tableView.dequeueReusableCell(withIdentifier: UploadPhotoCell.IDENTITY, for: indexPath) as! UploadPhotoCell
            if let image = currentUploadImage {
                cell.bind(image: image)
            }
            return cell
        case .comment:
            let cell: TextViewWithoutLabelCell = tableView.dequeueReusableCell(withIdentifier: TextViewWithoutLabelCell.IDENTITY, for: indexPath) as! TextViewWithoutLabelCell
            cell.textView.delegate = delegate
            return cell
        }
    }
    
    func bind() {
        self.tableView.reloadData()
    }
    
    func bind(image: UIImage) {
        self.currentUploadImage = image
        self.tableView.reloadData()
    }
}

extension ReportTaskDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch TableSection(rawValue: section)! {
        case .upload: fallthrough
        case .comment:
            return CGFloat(TableDelegate.SECTION_HEIGHT)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch TableSection(rawValue: indexPath.section)! {
        case .upload:
            return CGFloat(UploadPhotoCell.HEIGHT)
        case .comment:
            return CGFloat(TextViewWithoutLabelCell.HEIGHT)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch TableSection(rawValue: indexPath.section)! {
        case .upload:
            action.value = .upload
        case .comment:
            break
        }
    }
}
