//
//  ViewController.swift
//  SPReactiveSwift
//
//  Created by 825844231@qq.com on 01/31/2021.
//  Copyright (c) 2021 825844231@qq.com. All rights reserved.
//

import UIKit
import SPReactiveSwift

class ViewController: UIViewController {
 
    @SPObserve var name : String?
    let disposeBase : SPDisposeBase = SPDisposeBase()
    let textField : UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.$name.subscribe { (value) in
            print("获取新值为: \(value)")
        }.dispose(by: disposeBase)
        self.$name.map { (value) -> String in
            return "value is \(value)"
        }.subscribe { (value) in
            print("2获取新值为: \(value)")
        }.dispose(by: disposeBase)
        
        SPSignal { (subscription) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                subscription.send(value: "1")
            }
        }.subscribe { (str) in
            print("str is \(str)")
        }.dispose(by: disposeBase)
        self.$name.any().subscribe { (str) in
            print("any name is \(str)")
        }.dispose(by: disposeBase)
//        self.view.observe(<#T##keyPath: KeyPath<UIView, Value>##KeyPath<UIView, Value>#>, options: <#T##NSKeyValueObservingOptions#>, changeHandler: <#T##(UIView, NSKeyValueObservedChange<Value>) -> Void#>)
        
        self.view.addSubview(textField)
        
        SPKVO(target: textField, keyPath: \UITextField.text).subscribe { (text) in
            print("textField text is \(text)")
        }.dispose(by: disposeBase)
        SPAnyReactive<String?>(reactivable: self.$name).subscribe { (str) in
            
        }.dispose(by: disposeBase)
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.name = "22222"
        textField.text = "textField text"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

 
