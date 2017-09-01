//
//  UIApplication.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics
import CoreTelephony

extension UIApplication {
    fileprivate static let EnvKey = "EnvKey"
    
    open class var environment : Env {
        get {
            if let key = UserDefaults.standard.string(forKey: UIApplication.EnvKey), let val = Env(rawValue:key) {
                return val
            }
            return .prod
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: UIApplication.EnvKey)
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
            return UIApplication.buildType == .prod
        }
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

    open class func deviceSpecificClass<T>(baseClass cl:T)->T {
        if UIDevice.isIPad, let baseClass = cl as? AnyClass {
            let iPadClassName = String(describing: baseClass) + "iPad"
            if let iPadClass = NSClassFromString(iPadClassName) as? T {
                return iPadClass
            } else {
                fatalError("\(iPadClassName) not a subclass of \(baseClass)")
            }
        }
        return cl
    }
    
    open class func deviceSpecificClass<T>(for className:String)->T? {
        let name = UIApplication.deviceSpecificClassName(baseClass: className)
        return NSClassFromString(name) as? T
    }
    
    open class func deviceSpecificClassName(baseClass className: String)-> String {
        if UIDevice.isIPad {
            let iPadClassName = className + "iPad"
            if let _ = NSClassFromString(iPadClassName) {
                return iPadClassName
            } else {
                return className
            }
        }
        return className
    }
    
    open class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    open class var ruleThickness:CGFloat {
        return  1.0/UIDevice.screenScale
    }
    
    open class var buildNumber:Int {
        if let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String {
            return Int(build) ?? 0
        }
        return 0
    }
    
    open class var buildVersion: String {
        if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
            return text
        }
        return ""
    }
}

public enum Env : String {
    case stage, prod
}

public enum BuildType : String {
    case dev, beta, prod
}
