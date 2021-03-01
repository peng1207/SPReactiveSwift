//
//  SPDispose.swift
//  SPReactiveSwift
//
//  Created by 黄树鹏 on 2021/1/31.
//

import Foundation

public class SPDispose : SPDisposable {
    
    private let disposable : SPDisposable
    
    public init(disposable : SPDisposable) {
        self.disposable = disposable
    }
    
    public func dispose() {
        self.disposable.dispose()
    }
}
 
extension SPDispose {
    
    public func dispose(by disposeBase : SPDisposeBase){
        disposeBase.insert(dispose: self)
    }
    
}
