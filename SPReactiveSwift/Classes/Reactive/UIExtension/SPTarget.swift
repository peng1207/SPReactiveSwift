//
//  SPTarget.swift
//  SPReactiveSwift
//
//  Created by 黄树鹏 on 2021/2/2.
//

import Foundation
import UIKit

public class SPTarget<T> where T : UIView{
    
    let target : T
    public init(target : T) {
        self.target = target
    }
}
extension NSObjectProtocol where Self : UIView{
    public var sp : SPTarget<Self>{
        return SPTarget(target: self)
    }
}
extension SPTarget where T : UIButton{
    
}
extension SPTarget where T : UIView{
    public func tap()->SPAnyReactive<UITapGestureRecognizer>{
        let tap = UITapGestureRecognizer()
        return addGesture(gesture: tap)
    }
    public func longPress()->SPAnyReactive<UILongPressGestureRecognizer>{
        let longPress = UILongPressGestureRecognizer()
        return addGesture(gesture: longPress)
    }
    public func swipe()->SPAnyReactive<UISwipeGestureRecognizer>{
        let swipe = UISwipeGestureRecognizer()
        return addGesture(gesture: swipe)
    }
    public func pinch()->SPAnyReactive<UIPinchGestureRecognizer>{
        let pinch = UIPinchGestureRecognizer()
        return addGesture(gesture: pinch)
    }
    public func rotation()->SPAnyReactive<UIRotationGestureRecognizer>{
        let rotation = UIRotationGestureRecognizer()
        return addGesture(gesture: rotation)
    }
    public func pan()->SPAnyReactive<UIPanGestureRecognizer>{
        let pan = UIPanGestureRecognizer()
        return addGesture(gesture: pan)
    }
    public func screenEdgePan()->SPAnyReactive<UIScreenEdgePanGestureRecognizer>{
        let screenEdgePan = UIScreenEdgePanGestureRecognizer()
        return addGesture(gesture: screenEdgePan)
    }
    private func addGesture<G>(gesture : G)->SPAnyReactive<G> where G : UIGestureRecognizer{
        self.target.addGestureRecognizer(gesture)
        self.target.isUserInteractionEnabled = true
        
        return SPGestureRecognizer(gestureRecognizer: gesture).any()
    }
}
private var SPTextFieldKey = "SPTextFieldKey"
extension SPTarget where T : UITextField{
    
    private var disposeBase : SPDisposeBase{
        get{
            if let base =  objc_getAssociatedObject(self, SPTextFieldKey) as? SPDisposeBase {
                return base
            }
            let base = SPDisposeBase()
            self.disposeBase = base
           return base
        }
        set{
            objc_setAssociatedObject(self, SPTextFieldKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    public var text : SPAnyReactive<String?>{
        get{
            return SPKVO(target: self.target, keyPath: \T.text).any()
        }
        set{
            newValue.subscribe { (str) in

            }.dispose(by: disposeBase)
        }
    }
}
extension SPTarget where T  : UIScrollView{
    public var contentOffset : SPAnyReactive<CGPoint>{
        return SPKVO(target: self.target, keyPath: \T.contentOffset).any()
    }
    public var contentSize : SPAnyReactive<CGSize>{
        return SPKVO(target: self.target, keyPath: \T.contentSize).any()
    }
    
}
private var SPSliderKey = "SPSliderKey"
extension SPTarget where T  : UISlider{
    private var disposeBase : SPDisposeBase{
        get{
            if let base =  objc_getAssociatedObject(self, SPSliderKey) as? SPDisposeBase {
                return base
            }
            let base = SPDisposeBase()
            self.disposeBase = base
           return base
        }
        set{
            objc_setAssociatedObject(self, SPTextFieldKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    public var value : SPAnyReactive<Float>{
        get{
            SPKVO(target: self.target, keyPath: \T.value).any()
        }
        set{
            newValue.subscribe { [weak self](v) in
                self?.target.value = v
            }.dispose(by: self.disposeBase)
        }
    }
}
private var SPSwitchKey = "SPSwitchKey"
extension SPTarget where T : UISwitch{
    private var disposeBase : SPDisposeBase{
        get{
            if let base =  objc_getAssociatedObject(self, SPSliderKey) as? SPDisposeBase {
                return base
            }
            let base = SPDisposeBase()
            self.disposeBase = base
           return base
        }
        set{
            objc_setAssociatedObject(self, SPTextFieldKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    public var isOn : SPAnyReactive<Bool>{
        get{
            SPKVO(target: self.target, keyPath: \T.isOn).any()
        }
        set{
            newValue.subscribe { [weak self](v) in
                self?.target.isOn = v
            }.dispose(by: self.disposeBase)
        }
    }
}
private var SPProgressViewKey = "SPProgressViewKey"
extension SPTarget where T : UIProgressView{
    private var disposeBase : SPDisposeBase{
        get{
            if let base =  objc_getAssociatedObject(self, SPProgressViewKey) as? SPDisposeBase {
                return base
            }
            let base = SPDisposeBase()
            self.disposeBase = base
           return base
        }
        set{
            objc_setAssociatedObject(self, SPProgressViewKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    public var progress : SPAnyReactive<Float>{
        get{
            SPKVO(target: self.target, keyPath: \T.progress).any()
        }
        set{
            newValue.subscribe { [weak self](v) in
                self?.target.progress = v
            }.dispose(by: disposeBase)
        }
    }
}
private var SPControlKey = "SPControlKey"
extension SPTarget where T : UIControl {
    private var disposeBase : SPDisposeBase{
        get{
            if let base =  objc_getAssociatedObject(self, SPControlKey) as? SPDisposeBase {
                return base
            }
            let base = SPDisposeBase()
            self.disposeBase = base
           return base
        }
        set{
            objc_setAssociatedObject(self, SPControlKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public func add(event : UIControl.Event)->SPAnyReactive<T>{
        return SPControl(control: self.target, event: event).any()
    }
    public var isSelected : SPAnyReactive<Bool>{
        set{
            newValue.subscribe { [weak self](selected) in
                self?.target.isSelected = selected
            }.dispose(by: disposeBase)
        }
        get{
            SPKVO(target: self.target, keyPath: \T.isSelected).any()
        }
    }
    public var isEnabled : SPAnyReactive<Bool>{
        get{
            SPKVO(target: self.target, keyPath: \T.isEnabled).any()
        }
        set{
            newValue.subscribe { [weak self](enabled) in
                self?.target.isEnabled = enabled
            }.dispose(by: disposeBase)
        }
    }
    public var isHighlighted : SPAnyReactive<Bool>{
        get{
            SPKVO(target: self.target, keyPath: \T.isHighlighted).any()
        }
        set{
            newValue.subscribe { [weak self](highlighted) in
                self?.target.isHighlighted = highlighted
            }.dispose(by: disposeBase)
        }
    }

}
