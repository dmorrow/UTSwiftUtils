//
//  Color.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9, *)
extension UIColor {
    
    public var brightness:CGFloat {
        get {
            let components = self.rgba
            return components.r * 0.3 + components.g * 0.59 + components.b * 0.11
        }
    }
    
    public var rgba:(r: CGFloat, g: CGFloat, b: CGFloat, a:CGFloat) {
        get {
            var r:CGFloat = 0
            var g:CGFloat = 0
            var b:CGFloat = 0
            var a:CGFloat = 1
            self.getRed(&r, green: &g, blue:&b, alpha:&a)
            return (r, g, b, a)
        }
    }
    
    public var rgb:(r: CGFloat, g: CGFloat, b: CGFloat) {
        get {
            let rgba = self.rgba
            return (rgba.r, rgba.g, rgba.b)
        }
    }
    
    public var uint:UInt {
        get {
            if let components = self.cgColor.components {
                let r = UInt(components[0] * 255.0) << 16
                let g = UInt(components[1] * 255.0) << 8
                let b = UInt(components[2] * 255.0)
                return r + g + b
            }
            return 0
        }
    }
    
    public var hexString:String {
        get {
            return String(format:"#%06x", self.uint)
        }
    }
    
    /**
     Returns the default blue color as seen in navigation bars
     */
    public static var defaultBlue:UIColor {
        get {
            return UIButton(type:UIButton.ButtonType.system).titleColor(for: UIControl.State.normal)!
        }
    }
    
    public convenience init(hex: UInt) {
        self.init(hex:hex, alpha:1.0)
    }
    
    public convenience init(hex: UInt, alpha:CGFloat) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    public convenience init(hexString:String) {
        var hexString = hexString
        if hexString.hasPrefix("#")
        {
            hexString = hexString.substring(from: hexString.index(hexString.startIndex, offsetBy:1))
        }
        var rgbValue:UInt32 = 0
        Scanner(string: hexString as String).scanHexInt32(&rgbValue)
        self.init(hex:UInt(rgbValue), alpha:1)
    }
    
    public class func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256))/255.0
        let g = CGFloat(arc4random_uniform(256))/255.0
        let b = CGFloat(arc4random_uniform(256))/255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
        
    //interpolate receiver to second color by amount 0..1
    
    public func interpolate(to:UIColor, amount:CGFloat) -> UIColor {
        let delta = max(0.0, min(amount, 1.0))
     
        if let fromComponent = self.cgColor.components, let toComponent = to.cgColor.components {
            let startAlpha = self.cgColor.alpha
            let endAlpha = to.cgColor.alpha
         
            let r = fromComponent[0] + (toComponent[0] - fromComponent[0]) * delta
            let g = fromComponent[1] + (toComponent[1] - fromComponent[1]) * delta
            let b = fromComponent[2] + (toComponent[2] - fromComponent[2]) * delta
            let a = startAlpha + (endAlpha - startAlpha) * delta
            
            return UIColor(red:r, green: g, blue: b, alpha: a)
        }
        return self
    }
    
    /*
    factor 1 returns the same color
    factor > 1 returns brighter color
    factor < 1 returns darker color
    */
    public func shift(brightness factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self
        }
    }
}
