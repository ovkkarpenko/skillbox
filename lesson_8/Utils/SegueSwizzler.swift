//
//  Box.swift
//  lesson_8
//
//  Created by Oleksandr Karpenko on 15.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import Foundation

class Box {
    let value: Any
    init(_ value: Any) {
        self.value = value
    }
}

extension DispatchQueue {
    private static var onceTokens = [Int]()
    private static var internalQueue = DispatchQueue(label: "lesson_8.once")
    
    class func once(token: Int, closure: () -> Void) {
        internalQueue.sync {
            if onceTokens.contains(token) {
                return
            }
            onceTokens.append(token)
            closure()
        }
    }
    
}

private let Token = 0
private var AssociatedObjectHandle: UInt8 = 0

extension UIViewController {
    typealias ConfiguratePerformSegue = (UIStoryboardSegue) -> ()
    
    func performSegueWithIdentifier(identifier: String, sender: AnyObject?, configurate: ConfiguratePerformSegue?) {
        swizzlingPrepareForSegue()
        configuratePerformSegue = configurate
        performSegue(withIdentifier: identifier, sender: sender)
    }
    
    private func swizzlingPrepareForSegue() {
        DispatchQueue.once(token: Token) {
            let originalSelector = #selector(UIViewController.prepare)
            let swizzledSelector = #selector(UIViewController.closurePrepareForSegue(segue:sender:))
            
            let instanceClass = UIViewController.self
            let originalMethod = class_getInstanceMethod(instanceClass, originalSelector)!
            let swizzledMethod = class_getInstanceMethod(instanceClass, swizzledSelector)!
            
            let didAddMethod = class_addMethod(instanceClass, originalSelector,
                                               method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(instanceClass, swizzledSelector,
                                    method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    @objc func closurePrepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        configuratePerformSegue?(segue)
        closurePrepareForSegue(segue: segue, sender: sender)
        configuratePerformSegue = nil
    }
    
    var configuratePerformSegue: ConfiguratePerformSegue? {
        get {
            let box = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Box
            return box?.value as? ConfiguratePerformSegue
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, Box(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension UIImagePickerController {
    
}
