//
//  EditBookingRequestDataSource.swift
//  pochi
//
//  Created by akiho on 2017/10/21.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EditBookingRequestDataSource: NSObject, UITableViewDataSource {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private weak var delegate: UITextFieldDelegate? = nil
    fileprivate var formData: EditBookingRequestData = EditBookingRequestData()
    fileprivate let tableView: UITableView
    
    var observeInput: Observable<EditBookingRequestData.SendData> {
        return formData.observeInput()
    }
    
    init(tableView: UITableView, delegate: UITextFieldDelegate) {
        self.tableView = tableView
        self.delegate = delegate
        
        InputCellData.registerCell(tableView: self.tableView)
        
        super.init()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formData.getProperties().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inputCellData: InputCellData = formData.getProperties()[indexPath.row]
        let cell: InputCell = inputCellData.getCell(tableView: tableView, indexPath: indexPath)
        
        (cell.getInput() as? CalendarTextField)?.customDelegate = self
        (cell.getInput() as? UITextField)?.delegate = self.delegate
        
        return cell as! UITableViewCell
    }
    
    func bind(booking: Booking) {
        formData.startDate.value.value = booking.startDate ?? ""
        formData.endDate.value.value = booking.endDate ?? ""
        formData.point.value.value = booking.usePoint > 0 ? String(booking.usePoint) : ""
        formData.coupon.value.value = booking.hasCoupon ? String(booking.useCouponCode!) : ""
        
        if let date = booking.startDate {
            formData.endDate.calendarStartFrom = DateDelegate.stringToDate(dateString: date)
        }

        self.tableView.reloadData()
    }
    
    func bind(booking: Booking, dogs: Driver<[Dog]>) {
        dogs.drive(onNext: { items in
            self.formData.dogNames.selectItems = items.map({ $0.name })
            self.formData.dogNames.value.value = booking.dogIds.map({ id -> String in
                items.first(where: { dog -> Bool in
                    return dog.id == id
                })?.name ?? ""
            }).filter({ !$0.isEmpty }).joined(separator: ",")
            
            self.tableView.reloadData()
        })
        .addDisposableTo(disposeBag)
    }
    
    func bind(point: Driver<Int64>) {
        point.drive(onNext: { item in
            self.formData.point.rightLabel = "残ポイント：\(item)pt"
            self.tableView.reloadData()
        })
        .addDisposableTo(disposeBag)
    }
}

extension EditBookingRequestDataSource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return formData.getProperties()[indexPath.row].getCellHeight()
    }
}

extension EditBookingRequestDataSource: CalendarTextFieldDelegate {
    func select(value: Date) {
        if let date = DateDelegate.stringToDate(dateString: formData.startDate.value.value) {
            formData.endDate.calendarStartFrom = date
            tableView.reloadData()
        }
    }
}

