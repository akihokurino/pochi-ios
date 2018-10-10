//
//  Pagination.swift
//  pochi
//
//  Created by akiho on 2017/07/15.
//  Copyright © 2017年 akiho. All rights reserved.
//

import Foundation
import RxSwift

enum PaginationState {
    case hasNext
    case completed
}

class Pagination<A: HasPointer, T> {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let load: (String) -> Observable<A>
    private let convert: (A) -> T
    private var nextPointerHolder = PointerHolder(pointer: Pointer(nextCursor: ""))
    
    let subject: ReplaySubject = ReplaySubject<T>.create(bufferSize: 16)
    
    init(load: @escaping (String) -> Observable<A>, convert: @escaping (A) -> T) {
        self.load = load
        self.convert = convert
    }
    
    func next() {
        if let value = nextPointerHolder.getValue() {
            nextPointerHolder.setValue(value: nil)
            run(pointer: value)
        }
    }
    
    func destroy() {
        nextPointerHolder.setValue(value: nil)
        subject.onCompleted()
    }
    
    func refresh() -> Pagination<A, T> {
        destroy()
        return Pagination<A, T>(load: self.load, convert: self.convert)
    }

    private func run(pointer: Pointer) {
        Observable.just(pointer)
            .flatMap { pointer -> Observable<A> in
                return self.load(pointer.nextCursor)
            }
            .observeOn(CurrentThreadScheduler.instance)
            .subscribe(onNext: { result in
                let hasNext = result.pointer.hasNext
                
                if (hasNext) {
                    self.nextPointerHolder.setValue(value: result.pointer)
                }
                
                self.subject.onNext(self.convert(result))
                
                if !hasNext {
                    self.subject.onCompleted()
                }
            }, onError: { (error) in
                self.subject.onError(error)
            })
            .addDisposableTo(disposeBag)
    }
}

private class PointerHolder {
    private let l = NSRecursiveLock()
    private var value: Pointer?
    
    init(pointer: Pointer?) {
        self.value = pointer
    }
    
    func setValue(value: Pointer?) {
        self.safeCall(
            f: { () -> Void in
                self.value = value
            }
        )
    }
    
    func getValue() -> Pointer? {
        return self.safeCall(
            f: { () -> Pointer? in
                return self.value
            }
        )
    }
    
    private func lock() {
        self.l.lock()
    }
    
    private func unlock() {
        self.l.unlock()
    }
    
    private func safeCall<R>(f: () -> R) -> R {
        let r: R
        self.lock()
        r = f()
        self.unlock()
        return r
    }
}

