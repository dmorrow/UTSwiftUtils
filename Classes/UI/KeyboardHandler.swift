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
    func textfieldDidBeginEditing(_ notification: Notification)
    func textviewDidBeginEditing(_ notification: Notification)
}

public extension KeyboardHandler where Self: UIViewController  {
        
    public func addKeyboardObservers() {
        guard scrollableView != nil, observesKeyboard else { return }
        if !isObservingKeyboard {
            isObservingKeyboard = true
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector:#selector(keyboardResize(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(textfieldDidBeginEditing(_:)), name: UITextField.textDidBeginEditingNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(textviewDidBeginEditing(_:)), name: UITextView.textDidBeginEditingNotification, object: nil)
        }
    }
    
    public func removeKeyboardObservers() {
        if isObservingKeyboard {
            let notificationCenter = NotificationCenter.default
            notificationCenter.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            notificationCenter.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
            notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            notificationCenter.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
            notificationCenter.removeObserver(self, name: UITextField.textDidBeginEditingNotification, object: nil)
            notificationCenter.removeObserver(self, name: UITextView.textDidBeginEditingNotification, object: nil)
            isObservingKeyboard = false
        }
        
    }
    
}
