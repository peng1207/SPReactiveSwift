//
//  SPDisposeBase.swift
//  SPReactiveSwift
//
//  Created by 黄树鹏 on 2021/1/31.
//

import Foundation


public class SPDisposeBase {
    
    private var list : [SPDisposable] = []
    
    public func insert(dispose : SPDisposable){
        list.append(dispose)
    }
    public init() {
        
    }
    private func dispose(){
        list.forEach { (disposable) in
            disposable.dispose()
        }
        list.removeAll()
    }
    
    deinit {
        self.dispose()
    }
    
}
