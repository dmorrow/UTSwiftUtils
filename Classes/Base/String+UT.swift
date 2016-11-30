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
    
    public var glyphCount: Int {
        let richText = NSAttributedString(string: self)
        let line = CTLineCreateWithAttributedString(richText)
        return CTLineGetGlyphCount(line)
    }
    
    public var isSingleEmoji: Bool {
        return glyphCount == 1 && containsEmoji
    }
    
    public var containsEmoji: Bool {
        return unicodeScalars.map { $0 }.filter { $0.isEmoji }.count != 0
    }
    
    public var containsOnlyEmoji: Bool {
        return characters.count > 0 && characters.count == unicodeScalars.map { $0 }.filter { $0.isEmoji }.count
    }

    public var isValidEmail: Bool {
        do {
        let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.anchored, range:  NSMakeRange(0, self.characters.count)) != nil
        } catch {
            print(error)
        }
        return false
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
    
    //Substrings - http://stackoverflow.com/a/39742687/1189470
    
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.characters.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end > 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start > 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.characters.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return self[startIndex ..< endIndex]
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }
    
    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }
    
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }
        
        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }
        
        return self.substring(from: from, to: end)
    }
    
    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }
        
        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }
        
        return self.substring(from: start, to: to)
    }
}



extension UnicodeScalar {
    
    var isEmoji: Bool {
        
        switch value {
        case 0x3030, 0x00AE, 0x00A9, // Special Characters
        0x1D000 ... 0x1F77F, // Emoticons
        0x2100 ... 0x27BF, // Misc symbols and Dingbats
        0xFE00 ... 0xFE0F, // Variation Selectors:
        0x1F900 ... 0x1F9FF: // Supplemental Symbols and Pictographs
            return true
            
        default: return false
        }
    }
}
