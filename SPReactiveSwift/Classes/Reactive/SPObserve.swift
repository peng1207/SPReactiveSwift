//
//  SPObserve.swift
//  Pods-SPReactiveSwift_Example
//
//  Created by 黄树鹏 on 2021/1/31.
//

import Foundation


@propertyWrapper public struct SPObserve<V> {
    
    public var wrappedValue : V{
        set{
            self.reactive.subscription.update(with: newValue)
        }
        get{
            return self.reactive.subscription.value
        }
    }
    private let reactive : SPReactive

    public var projectedValue : SPObserve<V>.SPReactive {
        return reactive
    }
    
    public init(wrappedValue : V) {
        self.reactive = SPReactive(value: wrappedValue)
    }
    
    public struct SPReactive : SPReactivable {
        
        public typealias Output = V
        var subscription : SPReactiveSubscription
        
        init(value : V) {
            self.subscription = SPReactiveSubscription(value: value)
        }
        
        public func receive<S>(subscribe: S) -> SPSubscription where S : SPSubscribeable, Self.Output == S.Input {
            if let data =  subscribe as? SPSubscribe<V>{
                subscription.insert(by: data)
            }
            return subscription
        }
        
        internal class SPReactiveSubscription : SPSubscription {
            private var subscribes : [SPSubscribe<V>] = []
            internal var value : V
            init(value : V) {
                self.value = value
            }
            
            fileprivate func update(with value : V){
                self.value = value
                sendData(value: value)
            }
            private func sendData(value : V){
                subscribes.forEach { (subscribe) in
                    subscribe.receive(value: value)
                }
            }
            fileprivate func insert(by subscribe : SPSubscribe<V>){
                self.subscribes.append(subscribe)
            }
            func dispose() {
                subscribes.removeAll { (subscribe) -> Bool in
                     return subscribe.isDispose
                }
            }
            deinit {
                subscribes.removeAll()
            }
        }
    }
}

