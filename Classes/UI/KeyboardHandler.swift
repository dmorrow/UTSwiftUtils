//
//  KeyboardHandler.swift
//  UTSwiftUtils
//
//  Created by Danny Morrow on 11/17/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

@objc(KeyboardHandler)
public protocol KeyboardHandler {
    
    var scrollableView:UIScrollView? { get }
    var isObservingKeyboard:Bool { get set }
    
    func internalKeyboardWillShow(_ notification: Notification)
    func internalKeyboardDidShow(_ notification: Notification)
    func internalKeyboardWillHide(_ notification: Notification)
    func internalKeyboardDidHide(_ notification: Notification)
    func internalKeyboardResize(_ notification: Notification)
}

public extension KeyboardHandler where Self: UIViewController  {
        
    public func observeKeyboardNotifications() {
        if let _ = scrollableView, !isObservingKeyboard {
            isObservingKeyboard = true
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector:#selector(internalKeyboardResize(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
            notificationCenter.addObserver(self, selector: #selector(internalKeyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
            notificationCenter.addObserver(self, selector: #selector(internalKeyboardDidShow(_:)), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
            notificationCenter.addObserver(self, selector: #selector(internalKeyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
            notificationCenter.addObserver(self, selector: #selector(internalKeyboardDidHide(_:)), name:NSNotification.Name.UIKeyboardDidHide, object: nil)
        }
    }
    
    public func removeObserveKeyboardNotifications() {
        if isObservingKeyboard {
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
            notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
            notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            notificationCenter.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
            isObservingKeyboard = false
        }
        
    }
    
}
