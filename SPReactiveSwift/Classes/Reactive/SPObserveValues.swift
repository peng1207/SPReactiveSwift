//
//  SPObserveValues.swift
//  SPReactiveSwift
//
//  Created by 黄树鹏 on 2021/1/31.
//

import Foundation

public struct SPObserveValues {
    
    public struct TwoValues<R1,R2> : SPReactivable where R1 : SPReactivable,R2:SPReactivable{
        public typealias Output = (R1.Output,R2.Output)
        private var r1 : R1
        private var r2 : R2
        public init(r1 : R1,r2 : R2){
            self.r1 = r1
            self.r2 = r2
        }
        
        public func receive<S>(subscribe: S) -> SPSubscription where S : SPSubscribeable, Self.Output == S.Input {
            let subscription  = TwoValuesSubscription(subscribe: subscribe, r1: r1, r2: r2)
            return subscription
        }
        
        private class TwoValuesSubscription<S,R1,R2> : SPSubscription where S : SPSubscribeable,R1 : SPReactivable,R2 : SPReactivable,S.Input == (R1.Output,R2.Output){
            private var subscribe : S?
            private var r1 :R1
            private var r2 :R2
            private var disposeBase : SPDisposeBase = SPDisposeBase()
            private var values : Two<R1,R2>?
            init(subscribe : S,r1 :R1,r2 :R2) {
                self.subscribe = subscribe
                self.r1 = r1
                self.r2 = r2
                values = Two(r1: self.r1, r2: self.r2)
                addObserve()
            }
            private func addObserve(){
                self.r1.subscribe { [weak self](value) in
                    self?.values?.update(v1: value)
                    self?.dealComplete()
                }.dispose(by: disposeBase)
                self.r2.subscribe { [weak self](value) in
                    self?.values?.update(v2: value)
                    self?.dealComplete()
                }.dispose(by: disposeBase)
            }
            private func dealComplete(){
                if let canSend = values?.canSend(), canSend == true, let outValue = values?.outValue() as? (R1.Output,R2.Output) {
                    subscribe?.receive(value: outValue)
                }
            }
            
            func dispose() {
                self.subscribe = nil
            }
            deinit {
                
            }
        }
        
    }
    public struct ThreeValues<R1,R2,R3> : SPReactivable where R1 : SPReactivable, R2 : SPReactivable,R3
                                                                : SPReactivable{
        public typealias Output = (R1.Output,R2.Output,R3.Output)
        public var r1 :R1, r2 : R2,r3 : R3
        
        public init( r1 : R1, r2 : R2, r3 : R3) {
            self.r1 = r1
            self.r2 = r2
            self.r3 = r3
        }
        public func receive<S>(subscribe: S) -> SPSubscription where S : SPSubscribeable, Self.Output == S.Input {
            let subscription = ThreeValuesSubscription(subscribe: subscribe, r1: r1, r2: r2, r3: r3)
            return subscription
        }
        private class ThreeValuesSubscription<S> : SPSubscription where S : SPSubscribeable,S.Input == (R1.Output,R2.Output,R3.Output){
            public var r1 :R1, r2 : R2,r3 : R3
            public var subscribe : S?
            private var disposeBase : SPDisposeBase = SPDisposeBase()
            private var values : Three<R1,R2,R3>?
            init(subscribe : S, r1 :R1, r2 : R2,r3 : R3) {
                self.subscribe = subscribe
                self.r1 = r1
                self.r2 = r2
                self.r3 = r3
                values = Three(r1: self.r1, r2: self.r2, r3: self.r3)
                addObserve()
            }
            private func addObserve(){
                TwoValues(r1: r1, r2: r2).subscribe { [weak self](r1Value : R1.Output,r2Value : R2.Output) in
                    self?.values?.update(v1: (r1Value,r2Value))
                    self?.dealComplete()
                }.dispose(by: disposeBase)
                r3.subscribe { [weak self](r3Value) in
                    self?.values?.update(v2: r3Value)
                    self?.dealComplete()
                }.dispose(by: disposeBase)
            }
            private func dealComplete(){
                if let canSend = values?.canSend(), canSend == true, let outValue = values?.outValue() as? (R1.Output,R2.Output,R3.Output) {
                    subscribe?.receive(value: outValue)
                }
            }
            func dispose() {
                self.subscribe = nil
            }
            
            
        }
        
    }
    public struct FourValues<R1,R2,R3,R4> : SPReactivable where R1 : SPReactivable,R2 : SPReactivable,R3 : SPReactivable,R4 : SPReactivable{
        
        public typealias Output = (R1.Output,R2.Output,R3.Output,R4.Output)
        public var r1 :R1, r2 : R2,r3 : R3,r4 : R4
        init(r1 :R1, r2 : R2,r3 : R3,r4 : R4) {
            self.r1 = r1
            self.r2 = r2
            self.r3 = r3
            self.r4 = r4
        }
        public func receive<S>(subscribe: S) -> SPSubscription where S : SPSubscribeable, Self.Output == S.Input {
            let subscription = FourValuesSubscription(subscribe: subscribe, r1: r1, r2: r2, r3: r3, r4: r4)
            return subscription
        }
        private class FourValuesSubscription<S> : SPSubscription where S : SPSubscribeable,S.Input == (R1.Output,R2.Output,R3.Output,R4.Output) {
            public var r1 :R1, r2 : R2,r3 : R3,r4 : R4
            public var subscribe: S?
            private var disposeBase : SPDisposeBase = SPDisposeBase()
            private var values : Four<R1,R2,R3,R4>?
            init(subscribe: S,r1 :R1, r2 : R2,r3 : R3,r4 : R4) {
                self.subscribe = subscribe
                self.r1 = r1
                self.r2 = r2
                self.r3 = r3
                self.r4 = r4
                values = Four(r1: self.r1, r2: self.r2, r3: self.r3, r4: self.r4)
                addObserve()
            }
            private func addObserve(){
                ThreeValues(r1: r1, r2: r2, r3: r3).subscribe { [weak self](r1Value : R1.Output,r2Value : R2.Output,r3Value : R3.Output) in
                    self?.values?.update(v1: (r1Value,r2Value,r3Value))
                    self?.dealComplete()
                }.dispose(by: disposeBase)
                r4.subscribe { [weak self](r4Value) in
                    self?.values?.update(v2: r4Value)
                    self?.dealComplete()
                }.dispose(by: disposeBase)
            }
            private func dealComplete(){
                if let canSend = values?.canSend(), canSend == true, let outValue = values?.outValue() as? (R1.Output,R2.Output,R3.Output,R4.Output) {
                    subscribe?.receive(value: outValue)
                }
            }
            func dispose() {
                subscribe = nil
            }
        }
        
    }
    private struct Value<R>  where R : SPReactivable{
        var isReactive : Bool = false
        var outValue : Any?
        init(reactivable : R) {
            if let reactive = reactivable as? SPObserve<R.Output>.SPReactive {
                isReactive = true
                outValue = reactive.subscription.value
            }
        }
        /// 更新数据
        /// - Parameter value: 数据
        mutating func update(value : R.Output){
            self.outValue = value
            self.isReactive = true
        }
    }
    private struct Two<R1,R2> : Valueable where R1 : SPReactivable ,R2 : SPReactivable{
        var value1 : Value<R1>
        var value2 : Value<R2>
        
        init(r1 : R1 , r2 : R2) {
            value1 = Value(reactivable: r1)
            value2 = Value(reactivable: r2)
        }
        mutating func update(v1 : R1.Output){
            value1.update(value: v1)
        }
        mutating func update(v2 : R2.Output){
            value2.update(value: v2)
        }
        func canSend()->Bool{
            return value1.isReactive && value2.isReactive
        }
        func outValue()->(Any?,Any?){
            return (value1.outValue,value2.outValue)
        }
    }
    private struct Three<R1,R2,R3> : Valueable where R1 : SPReactivable, R2 : SPReactivable,R3 : SPReactivable{
       
        typealias V1Output = (R1.Output,R2.Output)
        typealias V2Output = R3.Output
        var value1 : Value<R1>
        var value2 : Value<R2>
        var value3 : Value<R3>
        init(r1 : R1 , r2 : R2,r3 : R3) {
            value1 = Value(reactivable: r1)
            value2 = Value(reactivable: r2)
            value3 = Value(reactivable: r3)
        }
        mutating func update(v1: (R1.Output, R2.Output)) {
            value1.update(value: v1.0)
            value2.update(value: v1.1)
        }
        mutating func update(v2: R3.Output) {
            value3.update(value: v2)
        }
        func canSend() -> Bool {
            return value1.isReactive && value2.isReactive && value3.isReactive
        }
        func outValue()->(Any?,Any?,Any?){
            return (value1.outValue,value2.outValue,value3.outValue)
        }
    }
    private struct Four<R1,R2,R3,R4> : Valueable where R1 : SPReactivable, R2 : SPReactivable,R3 : SPReactivable,R4 : SPReactivable{
     
        
        typealias V1Output = (R1.Output,R2.Output,R3.Output)
        
        typealias V2Output = R4.Output
        var value1 : Value<R1>
        var value2 : Value<R2>
        var value3 : Value<R3>
        var value4 : Value<R4>
        init(r1 : R1 , r2 : R2,r3 : R3,r4 : R4) {
            value1 = Value(reactivable: r1)
            value2 = Value(reactivable: r2)
            value3 = Value(reactivable: r3)
            value4 = Value(reactivable: r4)
        }
        mutating func update(v1: (R1.Output, R2.Output, R3.Output)) {
            value1.update(value: v1.0)
            value2.update(value: v1.1)
            value3.update(value: v1.2)
        }
        
        mutating func update(v2: R4.Output) {
            value4.update(value: v2)
        }
        
        func canSend() -> Bool {
            return value1.isReactive && value2.isReactive && value3.isReactive
        }
        func outValue()->(Any?,Any?,Any?,Any?){
            return (value1.outValue,value2.outValue,value3.outValue,value4.outValue)
        }
    }
   
}
private protocol Valueable {
    associatedtype V1Output
    associatedtype V2Output
    mutating func update(v1 : V1Output)
    mutating func update(v2 : V2Output)
    func canSend()->Bool
}
