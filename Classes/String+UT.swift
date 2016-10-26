//
//  String+UT.swift
//
//  Created by Daniel Morrow on 10/25/16.
//

import Foundation
import UIKit

extension String {
    
    public static var lineSeparator:String {
        get {
            return "\u{2028}"
        }
    }    
    
    public func truncateText(_ characters: Int) -> String {
        if self.characters.count <= characters {
            return self
        }
        
        let truncTitle = (self as NSString).substring(with: NSRange(location:0, length:characters))
        var trimmed = truncTitle.trimmingCharacters(in: CharacterSet.whitespaces)
        trimmed = trimmed + "..."
        
        return trimmed
    }
    
    @available(iOS 9, *)
    public func createLink(_ link: String, fontSize: CGFloat, linkColor:UIColor = UIColor.defaultBlue) -> NSMutableAttributedString {
        let linkString = NSMutableAttributedString(string: self)
        let range = NSMakeRange(0, linkString.length)
        
        linkString.beginEditing()
        linkString.addAttribute(NSLinkAttributeName, value: link, range: range)
        linkString.addAttribute(NSForegroundColorAttributeName, value: linkColor, range: range)
        linkString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleNone.rawValue, range: range)
        linkString.endEditing()

        return linkString
    }
}
