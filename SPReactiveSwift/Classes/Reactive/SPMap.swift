//
//  SPMap.swift
//  SPReactiveSwift
//
//  Created by 黄树鹏 on 2021/1/31.
//

import Foundation


public struct SPMap<R,O> : SPReactivable where R : SPReactivable{
    public typealias Output = O
    private var reactivable : R
    private var transform :  (R.Output)->Output
    init(reactivable:R,transform : @escaping (R.Output)->Output) {
        self.reactivable = reactivable
        self.transform = transform
    }
        
    public func receive<S>(subscribe: S) -> SPSubscription where S : SPSubscribeable, Self.Output == S.Input {
        let subscription = SPMapSubscription(subscribe: subscribe, reactivable: reactivable, transform: transform)
        return subscription
    }
    
    private class SPMapSubscription<S,R,Output>: SPSubscription where S : SPSubscribeable, R : SPReactivable,S.Input == Output {
        private var subscribe : S?
        private var reactivable : R
        private var transform :  (R.Output)->Output
        private var disposeBase : SPDisposeBase = SPDisposeBase()
        init(subscribe : S, reactivable : R,transform :  @escaping (R.Output)->Output) {
            self.subscribe = subscribe
            self.reactivable = reactivable
            self.transform = transform
            addObserve()
        }
        
        private func addObserve(){
            self.reactivable.subscribe { [weak self](value) in
                self?.dealComplete(outValue: value)
            }.dispose(by: disposeBase)
        }
        private func dealComplete(outValue : R.Output){
            let resultValue = self.transform(outValue)
            self.subscribe?.receive(value: resultValue)
        }
        
        func dispose() {
            self.subscribe = nil
        }
        deinit {
            
        }
        
    }
    
}
