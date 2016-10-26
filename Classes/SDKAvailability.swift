//
//  SDKAvailability.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics
import CoreTelephony

open class SDKAvailability {
    open static let EnvKey = "EnvKey"
    
    open class var isIPad:Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }

    open class var isIPhone:Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    open class var isIOS10:Bool {
        if #available(iOS 10, *)
        {
            return true
        }
        return false
    }
    
    open class var environment : Env {
        get {
            if let key = UserDefaults.standard.string(forKey: SDKAvailability.EnvKey), let val = Env(rawValue:key) {
                return val
            }
            return .prod
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: SDKAvailability.EnvKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    open class var buildType : BuildType {
        get {
            #if DEBUG
                return .dev
            #endif
            #if BETA
                return .beta
            #endif
            return .prod
        }
    }
    
    open class var isReleaseBuild : Bool {
        get {
            return SDKAvailability.buildType == .prod
        }
    }
    
    
    open class var isIPhone6:Bool {
        return SDKAvailability.deviceType == .iPhone6
    }
        
    open class var isIPhone6Plus:Bool {
        return SDKAvailability.deviceType == .iPhone6Plus
    }
        
    open class var deviceType:DeviceType {
        if SDKAvailability.isIPad
        {
            switch max(SDKAvailability.screenBounds.height, SDKAvailability.screenBounds.width)
            {
            case 1366:
                return .iPadPro;
            default:
                return .iPad;
            }
        }
        else if SDKAvailability.isIPhone
        {
            switch max(SDKAvailability.screenBounds.height, SDKAvailability.screenBounds.width)
            {
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
        return DeviceType.unknown
    }
        
    open class var canMakeCall:Bool {
        let canOpen = UIApplication.shared.canOpenURL(URL(string: "tel:5551234")!)
        //http://stackoverflow.com/questions/25873240/how-to-check-if-device-can-make-a-phone-call-ios-8
        if (canOpen)
        {
            // Check if iOS Device supports phone calls
            // User will get an alert error when they will try to make a phone call in airplane mode.
            if let _ = CTTelephonyNetworkInfo().subscriberCellularProvider?.mobileNetworkCode
            {
                return true
            }
        }
        
        return false
    }

    open class var screenScale:CGFloat {
        return UIScreen.main.scale
    }

    open class var isRetina:Bool {
        return SDKAvailability.screenScale >= 2
    }

    open class func deviceSpecificClassForBaseClass<T>(_ cl:T)->T {
        if (SDKAvailability.isIPad)
        {
            if let baseClass = cl as? AnyClass
            {
                let iPadClassName = NSStringFromClass(baseClass) + "iPad"
                if let iPadClass = NSClassFromString(iPadClassName)
                {
                    if let iPadReturn = iPadClass as? T
                    {
                        return iPadReturn
                    }
                    else
                    {
                        fatalError("\(iPadClass) not a subclass of \(baseClass)")
                    }
                }
            }
        }
        return cl
    }
    
    open class func deviceSpecificClassNameForBaseClassName(_ className: String)-> String {
        if (SDKAvailability.isIPad)
        {
            let iPadClassName = className + "iPad"
            if let _ = NSClassFromString(iPadClassName)
            {
                return iPadClassName
            } else {
                return className
            }
        }
        return className
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
    
    open class var ruleThickness:CGFloat {
        return  1.0/SDKAvailability.screenScale
    }
    
    open class var isPortrait:Bool {
        return SDKAvailability.screenBounds.height > SDKAvailability.screenBounds.width
    }
    
    open class var isLandscape:Bool {
        return !SDKAvailability.isPortrait
    }
    
    open class var buildNumber:Int {
        if let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String {
            return Int(build) ?? 0
        }
        return 0
    }
}

public enum DeviceType:String {
    case unknown, iPhone4, iPhone5, iPhone6, iPhone6Plus, iPad, iPadPro
}

public enum Env : String {
    case stage, prod
}

public enum BuildType : String {
    case dev, beta, prod
}
