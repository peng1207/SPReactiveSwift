//
//  SPNotification.swift
//  SPReactiveSwift
//
//  Created by 黄树鹏 on 2021/2/2.
//

import Foundation

public struct SPNotification : SPReactivable {
   
    
    public typealias Output = Notification
    private let subscription : SPNotificationSubscription<SPSubscribe<Output>>
   public init(name : Notification.Name) {
     
        subscription = SPNotificationSubscription(name: name)
    }
    
    public func receive<S>(subscribe: S) -> SPSubscription where S : SPSubscribeable, Self.Output == S.Input {
        if let subscribeable = subscribe as? SPSubscribe<Output>  {
            subscription.insert(subscribe: subscribeable)
        }
        return subscription
    }
    private class SPNotificationSubscription<S> : SPSubscription where S : SPSubscribeable ,S.Input == Notification {
        private let name : Notification.Name
        private var list : [SPSubscribe<Output>] = []
        init(name : Notification.Name) {
            self.name = name
            addObserve()
        }
        private func addObserve(){
            NotificationCenter.default.addObserver(forName: name, object: self, queue: nil) { [weak self](notification) in
                self?.list.forEach({ (subscribe) in
                    subscribe.receive(value: notification)
                })
            }
        }
        func insert(subscribe : SPSubscribe<Output>){
            list.append(subscribe)
        }
        func dispose() {
            list.removeAll { (subscribe) -> Bool in
                return subscribe.isDispose
            }
        }
    }
}
