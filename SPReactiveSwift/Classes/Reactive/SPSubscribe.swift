//
//  SPSubscribe.swift
//  Pods-SPReactiveSwift_Example
//
//  Created by 黄树鹏 on 2021/1/31.
//

import Foundation


public class SPSubscribe<V> : SPSubscribeable{
    public var isDispose: Bool = false
   
    public typealias Input = V
    private let complete : (Input)->Void
    private var subscription : SPSubscription?
    public init (complete : @escaping (Input)->Void){
        self.complete = complete
    }
    public func receive(subscription: SPSubscription) {
        self.subscription = subscription
    }
    public func dispose() {
        self.isDispose = true
        self.subscription?.dispose()
        self.subscription = nil
    }
    public func receive(value: V) {
        self.complete(value)
    }
}
