//
//  SPReactivable.swift
//  Pods-SPReactiveSwift_Example
//
//  Created by 黄树鹏 on 2021/1/31.
//

import Foundation


public protocol SPReactivable {
    
    associatedtype Output
    
    /// 接收数据
    /// - Parameter subscribe: 订阅用户
    func receive<S>(subscribe : S) -> SPSubscription where S : SPSubscribeable , Self.Output == S.Input
    
}


extension SPReactivable {
   public func subscribe(next complete:@escaping (Output)->Void) -> SPDispose{
        let subscribe  = SPSubscribe(complete: complete)
        subscribe.receive(subscription: receive(subscribe: subscribe))
        let dispose = SPDispose(disposable: subscribe)
        return dispose
    }
}

extension SPReactivable {
    public func map<R>(_ transform : @escaping (Output)->R)->SPMap<Self,R>{
        let map = SPMap(reactivable: self, transform: transform)
        return map
    }
}

extension SPReactivable {
    public func any()->SPAnyReactive<Self.Output>{
        let any = SPAnyReactive<Self.Output>(reactivable: self)
        return any
    }
}
