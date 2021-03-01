//
//  SPAnyReactive.swift
//  SPReactiveSwift
//
//  Created by 黄树鹏 on 2021/2/2.
//

import Foundation


public struct SPAnyReactive<O> : SPReactivable{
    public typealias Output = O
    
    
    private var subscription : SPAnySubscription
    
    public init<R>(reactivable: R) where R : SPReactivable ,R.Output == Output{
        subscription = SPAnySubscription(reactivable: reactivable)
    }
    
    public func receive<S>(subscribe: S) -> SPSubscription where S : SPSubscribeable, Self.Output == S.Input {
        if let s  = subscribe as? SPSubscribe<Output> {
            subscription.insert(subscribe: s)
        }
        return subscription
    }
    private class SPAnySubscription : SPSubscription {
        private var disposeBase : SPDisposeBase = SPDisposeBase()
        private var list : [SPSubscribe<Output>] = []
        init<R>(reactivable: R) where R : SPReactivable ,R.Output == Output {
            reactivable.subscribe { [weak self](outValue) in
                self?.dealComplete(out: outValue)
            }.dispose(by: disposeBase)
        }
        private func dealComplete(out value : Output){
            list.forEach { (subscribe) in
                subscribe.receive(value: value)
            }
        }
        func insert(subscribe : SPSubscribe<Output>) {
            list.append(subscribe)
        }
        
        func dispose() {
            list.removeAll { (subscribe) -> Bool in
                return subscribe.isDispose
            }
        }
    }
    
}
