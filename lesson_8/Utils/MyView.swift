//
//  MyView.swift
//  lesson_8
//
//  Created by Oleksandr Karpenko on 15.09.2020.
//  Copyright © 2020 Oleksandr Karpenko. All rights reserved.
//

import UIKit

private var AssociatedObjectHandle: UInt8 = 0

extension UIView {
    
    @IBInspectable var identifier: String {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as! String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, Box(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
}
