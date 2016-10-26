//
//  UIDevice+UT.swift
//  UTSwiftUtils
//
//  Created by Danny Morrow on 10/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    
    open class var isIPad:Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    open class var isIPhone:Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    open class var isIOS10:Bool {
        if #available(iOS 10, *) {
            return true
        }
        return false
    }
    
    open class var isIPhone6:Bool {
        return UIDevice.deviceSizeClass == .iPhone6
    }
    
    open class var isIPhone6Plus:Bool {
        return UIDevice.deviceSizeClass == .iPhone6Plus
    }
    
    open class var deviceSizeClass:DeviceSizeClass {
        if UIDevice.isIPad
        {
            switch max(UIDevice.screenBounds.height, UIDevice.screenBounds.width) {
            case 1366:
                return .iPadPro
            default:
                return .iPad
            }
        } else if UIDevice.isIPhone {
            switch max(UIDevice.screenBounds.height, UIDevice.screenBounds.width) {
            case 736:
                return .iPhone6Plus
            case 667:
                return .iPhone6
            case 568:
                return .iPhone5
            case 480:
                return .iPhone4
            default:
                return .unknown
            }
        }
        return .unknown
    }
    
    open class var screenBounds:CGRect {
        var bounds = UIScreen.main.bounds
        let orientation = UIApplication.shared.statusBarOrientation
        let landscape = (orientation == UIInterfaceOrientation.landscapeLeft || orientation == UIInterfaceOrientation.landscapeRight)
        if (landscape && bounds.height > bounds.width) {
            bounds = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.width)
        }
        return bounds
    }
    
    open class var screenScale:CGFloat {
        return UIScreen.main.scale
    }
    
    open class var isRetina:Bool {
        return UIDevice.screenScale >= 2
    }
    
    open class var isPortrait:Bool {
        return UIDevice.screenBounds.height > UIDevice.screenBounds.width
    }
    
    open class var isLandscape:Bool {
        return !UIDevice.isPortrait
    }
}

public enum DeviceSizeClass:String {
    case unknown, iPhone4, iPhone5, iPhone6, iPhone6Plus, iPad, iPadPro
}
