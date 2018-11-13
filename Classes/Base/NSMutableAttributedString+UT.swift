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
    
    public func setAttribute(_ name: NSAttributedString.Key, value:AnyObject) {
        self.removeAttribute(name, range: self.range)
        self.addAttribute(name, value: value, range: self.range)
    }
    
    public var backgroundColor:UIColor {
        get {
            return self.attribute(NSAttributedString.Key.backgroundColor, at: 0, effectiveRange: nil) as! UIColor
        }
        set {
            self.setAttribute(NSAttributedString.Key.backgroundColor, value: newValue)
        }
    }
    
    public var baselineOffset:CGFloat {
        get {
            return CGFloat(((self.attribute(NSAttributedString.Key.baselineOffset, at: 0, effectiveRange: nil) as AnyObject).floatValue)!)
        }
        set {
            self.setAttribute(NSAttributedString.Key.baselineOffset, value: newValue as AnyObject)
        }
    }
    
    public var font:UIFont {
        get {
            return self.attribute(NSAttributedString.Key.font, at: 0, effectiveRange: nil) as! UIFont
        }
        set {
            self.setAttribute(NSAttributedString.Key.font, value: newValue)
        }
    }
    
    public var color:UIColor {
        get {
            return self.attribute(NSAttributedString.Key.foregroundColor, at: 0, effectiveRange: nil) as! UIColor
        }
        
        set {
            self.setAttribute(NSAttributedString.Key.foregroundColor, value: newValue)
        }
    }
    
    public var kerning:CGFloat {
        get {
            return CGFloat(((self.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: nil) as AnyObject).floatValue)!)
        }
        set {
            self.setAttribute(NSAttributedString.Key.kern, value: newValue as AnyObject)
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
            return ((self.attribute(NSAttributedString.Key.ligature, at: 0, effectiveRange: nil) as AnyObject).intValue)!
        }
        set {
            self.setAttribute(NSAttributedString.Key.ligature, value: newValue as AnyObject)
        }
    }
    
    public var link:URL {
        get {
            return self.attribute(NSAttributedString.Key.link, at: 0, effectiveRange: nil) as! URL
        }
        set {
            self.setAttribute(NSAttributedString.Key.link, value: newValue as AnyObject)
        }
    }
    
    public var strokeWidth:CGFloat {
        get {
            return CGFloat(((self.attribute(NSAttributedString.Key.strokeWidth, at: 0, effectiveRange: nil) as AnyObject).floatValue)!)
        }
        set {
            self.setAttribute(NSAttributedString.Key.strokeWidth, value: newValue as AnyObject)
        }
    }
    
    public var strokeColor:UIColor {
        get {
            return self.attribute(NSAttributedString.Key.strokeColor, at: 0, effectiveRange: nil) as! UIColor
        }
        set {
            self.setAttribute(NSAttributedString.Key.strokeColor, value: newValue)
        }
    }
    
    var superscript:Int {
        get {
            return ((self.attribute(NSAttributedString.Key(rawValue: String(kCTSuperscriptAttributeName)), at: 0, effectiveRange: nil) as AnyObject).intValue)!
        }
        set {
            self.setAttribute(NSAttributedString.Key(rawValue: String(kCTSuperscriptAttributeName)), value: newValue as AnyObject)
        }
    }
    
    public var underlineColor:UIColor {
        get {
            return self.attribute(NSAttributedString.Key.underlineColor, at: 0, effectiveRange: nil) as! UIColor
        }
        set {
            self.setAttribute(NSAttributedString.Key.underlineColor, value: newValue)
        }
    }
    
    public var underlineStyle:NSUnderlineStyle {
        get {
            if let style = self.attribute(NSAttributedString.Key.underlineStyle, at: 0, effectiveRange: nil) as? NSUnderlineStyle {
                return style
            }
            return []
        }
        set {
            self.setAttribute(NSAttributedString.Key.underlineStyle, value: newValue.rawValue as AnyObject)
        }
    }
    
    public var paragraphStyle:NSParagraphStyle {
        get {
            if let  existingParagraphStyle = self.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle {
                return existingParagraphStyle
            }
            return NSParagraphStyle.default
        }
        set {
            self.setAttribute(NSAttributedString.Key.paragraphStyle, value: newValue)
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
