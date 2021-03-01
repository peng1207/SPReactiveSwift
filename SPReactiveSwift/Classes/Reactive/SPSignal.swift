//
//  SPSignal.swift
//  SPReactiveSwift
//
//  Created by 黄树鹏 on 2021/2/2.
//

import Foundation



public struct SPSignal<O> : SPReactivable{
    public typealias Output = O
    
    private let subscription : SPSignalSubscription = SPSignalSubscription()
    public init(complete : (SPSignalSubscription)->Void) {
        complete(subscription)
    }
    public func receive<S>(subscribe: S) -> SPSubscription where S : SPSubscribeable, Self.Output == S.Input {
        if let s  = subscribe as? SPSubscribe<Output> {
            subscription.insert(subscribe: s)
        }
        return subscription
    }
    
    public class SPSignalSubscription : SPSubscription{
        private var list : [SPSubscribe<O>] = []
        public func dispose() {
            
        }
        func insert(subscribe : SPSubscribe<O>) {
            list.append(subscribe)
        }
        public func send(value : O){
            list.forEach { (subscribe) in
                subscribe.receive(value: value)
            }
        }
        public func sendComplete(){
            list.forEach { (subscribe) in
                subscribe.dispose()
            }
            list.removeAll()
        }
    }
    
}
