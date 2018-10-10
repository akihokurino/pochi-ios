//
//  MessageViewModel.swift
//  pochi
//
//  Created by akiho on 2017/04/27.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MessageViewModel {
    
    enum Event {
        case none
        case refreshed
        case completedMessagePagination
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    private var messagePagination: Pagination<ItemsResponse<MessageResponse>, [Message]>?
    private var messages: Variable<[Message]> = Variable<[Message]>([])
    private var event: Variable<Event> = Variable(.none)
    private var isRefreshing: Bool = false
    
    private(set) var booking: Booking
    
    var observeEvent: Driver<Event> {
        return event.asDriver()
    }

    var observeMessages: Driver<[Message]> {
        return self.messages.asDriver()
    }
    
    init(booking: Booking) {
        self.booking = booking
        
        messagePagination = MessageRepository.shared.fetchAll(booking: booking)
        observeMessagePagination()
        fetchMessagesEachPage()
    }
    
    func refresh() {
        self.isRefreshing = true
        messagePagination = messagePagination?.refresh()
        observeMessagePagination()
        fetchMessagesEachPage()
    }
    
    private func observeMessagePagination() {
        messagePagination?.subject.asObservable()
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .do(onNext: { _ in
                if self.isRefreshing {
                    self.messages.value = []
                    self.event.value = .refreshed
                    self.isRefreshing = false
                }
            })
            .subscribe(onNext: { items in
                self.messages.value.append(contentsOf: items)
            }, onError: { e in
                
            }, onCompleted: {
                self.event.value = .completedMessagePagination
            })
            .addDisposableTo(disposeBag)
    }
    
    func fetchMessagesEachPage() {
        messagePagination?.next()
    }

    func createMessage(text: String) -> Observable<Message> {
        let createMessageData = CreateMessageData(content: text)
        return MessageRepository.shared.create(booking: booking, data: createMessageData)
            .do(onNext: { item in
                self.messages.value.insert(item, at: 0)
            })
    }
    
    func createMessage(image: UIImage) -> Observable<Message> {
        return MessageRepository.shared.create(booking: booking, image: image)
            .do(onNext: { item in
                self.messages.value.insert(item, at: 0)
            })
    }
    
    func sync(booking: Booking) {
        self.booking = booking
    }
}
