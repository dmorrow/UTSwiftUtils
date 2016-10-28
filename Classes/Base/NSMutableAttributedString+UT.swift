//
//  NSMutableAttributedString+UT.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit
import CoreText

@available(iOS 9, *)
extension NSMutableAttributedString
{
    public var range:NSRange {
        get {
            return NSMakeRange(0, self.length)
        }
    }
    
    public func setMultiple(_ properties:NSDictionary) {
        for (key, value) in properties
        {
            //NSAssert([self respondsToSelector:NSSelectorFromString(key)], @"trying to set nonexistant property: '%@'", key)
            self.setValue(value, forKey: key as! String)
        }
    }
    
    public func setAttribute(_ name:String, value:AnyObject) {
        self.removeAttribute(name, range: self.range)
        self.addAttribute(name, value: value, range: self.range)
    }
    
    public var backgroundColor:UIColor {
        get {
            return self.attribute(NSBackgroundColorAttributeName, at: 0, effectiveRange: nil) as! UIColor
        }
        set {
            self.setAttribute(NSBackgroundColorAttributeName, value: newValue)
        }
    }
    
    public var baselineOffset:CGFloat {
        get {
            return CGFloat(((self.attribute(NSBaselineOffsetAttributeName, at: 0, effectiveRange: nil) as AnyObject).floatValue)!)
        }
        set {
            self.setAttribute(NSBaselineOffsetAttributeName, value: newValue as AnyObject)
        }
    }
    
    public var font:UIFont {
        get {
            return self.attribute(NSFontAttributeName, at: 0, effectiveRange: nil) as! UIFont
        }
        set {
            self.setAttribute(NSFontAttributeName, value: newValue)
        }
    }
    
    public var color:UIColor {
        get {
            return self.attribute(NSForegroundColorAttributeName, at: 0, effectiveRange: nil) as! UIColor
        }
        
        set {
            self.setAttribute(NSForegroundColorAttributeName, value: newValue)
        }
    }
    
    public var kerning:CGFloat {
        get {
            return CGFloat(((self.attribute(NSKernAttributeName, at: 0, effectiveRange: nil) as AnyObject).floatValue)!)
        }
        set {
            self.setAttribute(NSKernAttributeName, value: newValue as AnyObject)
        }
    }
    
    public var photoshopKerning:CGFloat {
        get {
            return self.kerning * 1000.0 / self.font.pointSize
        }
        set {
            self.kerning = NSMutableAttributedString.kerningFromPhotoshopKerning(photoshopKerning, pointSize: self.font.pointSize)
        }
    }
    
    public static func kerningFromPhotoshopKerning(_ psKerning:CGFloat, pointSize:CGFloat)->CGFloat {
        return psKerning / 1000.0 * pointSize
    }
    
    public var ligature:Int {
        get {
            return ((self.attribute(NSLigatureAttributeName, at: 0, effectiveRange: nil) as AnyObject).intValue)!
        }
        set {
            self.setAttribute(NSLigatureAttributeName, value: newValue as AnyObject)
        }
    }
    
    public var link:URL {
        get {
            return self.attribute(NSLinkAttributeName, at: 0, effectiveRange: nil) as! URL
        }
        set {
            self.setAttribute(NSLinkAttributeName, value: newValue as AnyObject)
        }
    }
    
    public var strokeWidth:CGFloat {
        get {
            return CGFloat(((self.attribute(NSStrokeWidthAttributeName, at: 0, effectiveRange: nil) as AnyObject).floatValue)!)
        }
        set {
            self.setAttribute(NSStrokeWidthAttributeName, value: newValue as AnyObject)
        }
    }
    
    public var strokeColor:UIColor {
        get {
            return self.attribute(NSStrokeColorAttributeName, at: 0, effectiveRange: nil) as! UIColor
        }
        set {
            self.setAttribute(NSStrokeColorAttributeName, value: newValue)
        }
    }
    
    var superscript:Int {
        get {
            return ((self.attribute(String(kCTSuperscriptAttributeName), at: 0, effectiveRange: nil) as AnyObject).intValue)!
        }
        set {
            self.setAttribute(String(kCTSuperscriptAttributeName), value: newValue as AnyObject)
        }
    }
    
    public var underlineColor:UIColor {
        get {
            return self.attribute(NSUnderlineColorAttributeName, at: 0, effectiveRange: nil) as! UIColor
        }
        set {
            self.setAttribute(NSUnderlineColorAttributeName, value: newValue)
        }
    }
    
    public var underlineStyle:NSUnderlineStyle {
        get {
            if let style =  NSUnderlineStyle(rawValue: ((self.attribute(NSUnderlineStyleAttributeName, at: 0, effectiveRange: nil) as AnyObject).intValue)!)
            {
                return style
            }
            return NSUnderlineStyle.styleNone
        }
        set {
            self.setAttribute(NSUnderlineStyleAttributeName, value: newValue.rawValue as AnyObject)
        }
    }
    
    public var paragraphStyle:NSParagraphStyle {
        get {
            if let  existingParagraphStyle = self.attribute(NSParagraphStyleAttributeName, at: 0, effectiveRange: nil) as? NSParagraphStyle {
                return existingParagraphStyle
            }
            return NSParagraphStyle.default
        }
        set {
            self.setAttribute(NSParagraphStyleAttributeName, value: newValue)
        }
    }
    
    fileprivate var mutableParagraphStyle: NSMutableParagraphStyle {
        return self.paragraphStyle.mutableCopy() as! NSMutableParagraphStyle
    }
    
    public var lineSpacing:CGFloat {
        get {
            return self.paragraphStyle.lineSpacing
        }
        set {
            let paragraphStyle = self.mutableParagraphStyle
            paragraphStyle.lineSpacing = newValue
            self.paragraphStyle = paragraphStyle
        }
    }
    
    public var alignment:NSTextAlignment {
        get {
            return self.paragraphStyle.alignment
        }
        set {
            let paragraphStyle = self.mutableParagraphStyle
            paragraphStyle.alignment = newValue
            self.paragraphStyle = paragraphStyle
        }
    }
    
    public var paragraphSpacing:CGFloat {
        get {
            return self.paragraphStyle.paragraphSpacing
        }
        set {
            let paragraphStyle = self.mutableParagraphStyle
            paragraphStyle.paragraphSpacing = newValue
            self.paragraphStyle = paragraphStyle
        }
    }
    
    public var lineHeightMultiple:CGFloat {
        get {
            return self.paragraphStyle.lineHeightMultiple
        }
        set {
            let paragraphStyle = self.mutableParagraphStyle
            paragraphStyle.lineHeightMultiple = newValue
            self.paragraphStyle = paragraphStyle
        }
    }
    
    public var lineBreakMode:NSLineBreakMode {
        get {
            return self.paragraphStyle.lineBreakMode
        }
        set {
            let paragraphStyle = self.mutableParagraphStyle
            paragraphStyle.lineBreakMode = newValue
            self.paragraphStyle = paragraphStyle
        }
    }
}
