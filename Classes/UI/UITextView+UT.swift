//
//  UITextView+UT.swift
//  UTSwiftUtils
//
//  Created by Danny Morrow on 12/6/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    
    open func rect(forRange range:NSRange) -> CGRect? {
        guard let textRange = textRange(forRange: range) else {
            return nil
        }
        
        let rect = firstRect(for: textRange)
        return convert(rect, from:textInputView)
    }
    
    open func textRange(forRange range:NSRange) -> UITextRange? {
        guard let start = position(from: beginningOfDocument, offset: range.location), let end = position(from:start, offset: range.length) else {
            return nil
        }
        return textRange(from: start, to: end)
        
    }
}
