//
//  SegueSwizzler.swift
//  lesson_9_1
//
//  Created by Oleksandr Karpenko on 16.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit
import Foundation

class Box {
    var value: Any
    
    init(_ value: Any) {
        self.value = value
    }
}

extension UIViewController {
    
    struct AssociatedKey {
        static var ClosurePrepareForSegueKey = "ClosurePrepareForSegueKey"
    }
    
    typealias ConfiguratePerformSegue = (UIStoryboardSegue) -> ()
    var configuratePerformSegue: ConfiguratePerformSegue? {
        get {
            let box = objc_getAssociatedObject(self, &AssociatedKey.ClosurePrepareForSegueKey) as? Box
            return box?.value as? ConfiguratePerformSegue
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKey.ClosurePrepareForSegueKey,
                                     Box(newValue),
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func performSegueWithIdentifier(identifier: String, sender: AnyObject?, _ callback: ConfiguratePerformSegue?) {
        UIViewController.swizzlingSegue.toggle()
        configuratePerformSegue = callback
        performSegue(withIdentifier: identifier, sender: sender)
    }
    
    fileprivate static var swizzlingSegue: Bool = {
        let originalSelector = #selector(UIViewController.prepare)
        let swizzledSelector = #selector(UIViewController.closurePrepareForSegue(segue:sender:))
        
        let instanceClass = UIViewController.self
        let originalMethod = class_getInstanceMethod(instanceClass, originalSelector)!
        let swizzledMethod = class_getInstanceMethod(instanceClass, swizzledSelector)!
        
        let didAddMethod = class_addMethod(instanceClass, originalSelector,
                                           method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(instanceClass, swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        return true
    }()
    
    @objc func closurePrepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        configuratePerformSegue?(segue)
        closurePrepareForSegue(segue: segue, sender: sender)
        configuratePerformSegue = nil
    }
    
}
