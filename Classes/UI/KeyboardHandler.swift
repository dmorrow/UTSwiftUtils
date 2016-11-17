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
    var observesKeyboard:Bool { get }
    
    func keyboardWillShow(_ notification: Notification)
    func keyboardDidShow(_ notification: Notification)
    func keyboardWillHide(_ notification: Notification)
    func keyboardDidHide(_ notification: Notification)
    func keyboardResize(_ notification: Notification)
}

public extension KeyboardHandler where Self: UIViewController  {
        
    public func addKeyboardObservers() {
        guard scrollableView != nil, observesKeyboard else { return }
        if !isObservingKeyboard {
            isObservingKeyboard = true
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector:#selector(keyboardResize(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
            notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
            notificationCenter.addObserver(self, selector: #selector(keyboardDidShow(_:)), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
            notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
            notificationCenter.addObserver(self, selector: #selector(keyboardDidHide(_:)), name:NSNotification.Name.UIKeyboardDidHide, object: nil)
        }
    }
    
    public func removeKeyboardObservers() {
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
