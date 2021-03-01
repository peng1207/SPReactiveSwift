//
//  SPGestureRecognizer.swift
//  SPReactiveSwift
//
//  Created by 黄树鹏 on 2021/2/2.
//

import Foundation


public struct SPGestureRecognizer<GestureRecognizer> : SPReactivable where GestureRecognizer : UIGestureRecognizer {
   
    public typealias Output = GestureRecognizer
    private let gestureRecognizer :  GestureRecognizer
    
    public init(gestureRecognizer : GestureRecognizer) {
        self.gestureRecognizer = gestureRecognizer
    }
    
    public func receive<S>(subscribe: S) -> SPSubscription where S : SPSubscribeable, Self.Output == S.Input {
        let subscription = SPGestureRecognizerSubscription(subscribe: subscribe, gestureRecognizer: gestureRecognizer)
        return subscription
    }
    
    private class SPGestureRecognizerSubscription<S,GestureRecognizer> : SPSubscription where S : SPSubscribeable,GestureRecognizer : UIGestureRecognizer,S.Input == GestureRecognizer {
        
        private var subscribe : S?
        private var gestureRecognizer : GestureRecognizer
        
        init(subscribe : S,gestureRecognizer : GestureRecognizer) {
            self.subscribe = subscribe
            self.gestureRecognizer = gestureRecognizer
            addObserve()
        }
        private func addObserve(){
            gestureRecognizer.addTarget(self, action: #selector(gestureEvent))
        }
        @objc private func gestureEvent(){
            self.subscribe?.receive(value: gestureRecognizer)
        }
        
        func dispose() {
            self.subscribe = nil
        }
    }
    
}
