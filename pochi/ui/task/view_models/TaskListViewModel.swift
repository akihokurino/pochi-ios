//
//  TaskListViewModel.swift
//  pochi
//
//  Created by akiho on 2017/06/29.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TaskListViewModel {
    
    enum Event {
        case none
        case refreshed
        case empty
        case completedTaskPagination
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var tasks: Variable<[UserTaskWithSection]> = Variable([])
    private var event: Variable<Event> = Variable(.none)
    private var isRefreshing: Bool = false
    
    var selectedTask: UserTask?
    
    var observeTasks: Driver<[UserTaskWithSection]> {
        return tasks.asDriver()
    }
    
    var observeEvent: Driver<Event> {
        return event.asDriver()
    }
    
    func fetchAll() {
        UserTaskRepository.shared.fetchAll()
            .do(onNext: { _ in
                if self.isRefreshing {
                    self.tasks.value = []
                    self.event.value = .refreshed
                    self.isRefreshing = false
                }
            })
            .subscribe(onNext: { items in
                self.tasks.value = items
            }, onError: { e in
                
            }, onCompleted: {
                if self.tasks.value.isEmpty {
                    self.event.value = .empty
                }
                
                self.event.value = .completedTaskPagination
            })
            .addDisposableTo(disposeBag)
    }
    
    func refresh() {
        isRefreshing = true
        fetchAll()
    }
}

