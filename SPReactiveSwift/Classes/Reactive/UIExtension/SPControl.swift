//
//  SPControl.swift
//  SPReactiveSwift
//
//  Created by 黄树鹏 on 2021/2/2.
//

import Foundation


public struct SPControl<Control> : SPReactivable where Control : UIControl{
    public typealias Output = Control
    private let control : Control
    private let event : Control.Event
    public init(control :Control,event : Control.Event) {
        self.control = control
        self.event = event
    }
    public func receive<S>(subscribe: S) -> SPSubscription where S : SPSubscribeable, Self.Output == S.Input {
        let subscription = SPControlSubscription(subscribe: subscribe, control: control, event: event)
        return subscription
    }
    private class SPControlSubscription<Control,S> : SPSubscription where Control : UIControl ,S : SPSubscribeable ,S.Input == Control{
        private let control : Control
        private let event : Control.Event
        private var subscribe : S?
        init(subscribe : S, control :Control,event : Control.Event) {
            self.subscribe = subscribe
            self.control = control
            self.event = event
            addObserve()
        }
        private func addObserve(){
            self.control.addTarget(self, action: #selector(eventAction), for: event)
        }
        
        @objc private func eventAction(){
            subscribe?.receive(value: self.control)
        }
        
        func dispose() {
            subscribe = nil
        }
        
    }
}



