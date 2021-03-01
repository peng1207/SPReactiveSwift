//
//  SPKVO.swift
//  SPReactiveSwift
//
//  Created by 黄树鹏 on 2021/2/2.
//

import Foundation

 
public struct SPKVO<T,V> : SPReactivable where T : NSObject {
   
    
    public typealias Output = V
    private let target : T
    private let keyPath : KeyPath<T,V>
    
   public init(target : T,keyPath : KeyPath<T,V>) {
        self.target = target
        self.keyPath = keyPath
    }
    
    public func receive<S>(subscribe: S) -> SPSubscription where S : SPSubscribeable, Self.Output == S.Input {
        let subscription  = SPKVOSubscription(subscribe: subscribe, target: target, keyPath: keyPath)
        return subscription
    }
    private class SPKVOSubscription<S,T,V>  : SPSubscription where S : SPSubscribeable,T : NSObject,S.Input == V{
        
        private var subscribe : S?
        private let target : T
        private let keyPath : KeyPath<T,V>
        private var observation : NSKeyValueObservation?
        init(subscribe: S,target : T,keyPath : KeyPath<T,V>) {
            self.subscribe = subscribe
            self.target = target
            self.keyPath = keyPath
            addObserve()
        }
        
        private func addObserve(){
            self.observation = self.target.observe(keyPath, options: .new) { [weak self](t, v) in
                if let newValue = v.newValue{
                    self?.subscribe?.receive(value: newValue)
                }
            }
        }
        func dispose() {
            self.subscribe = nil
            self.observation = nil
        }
    }
}



