//
//  SPSubscribeable.swift
//  Pods-SPReactiveSwift_Example
//
//  Created by 黄树鹏 on 2021/1/31.
//

import Foundation


public protocol SPSubscribeable : SPDisposable{
    associatedtype Input
    /// 是否销毁
    var isDispose : Bool {get set}
    func receive(subscription : SPSubscription)
    func receive(value : Input)
    
}
