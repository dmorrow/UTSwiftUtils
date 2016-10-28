//
//  Reusable.swift
//  UTSwiftUtils
//
//  Created by Danny Morrow on 10/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public protocol Reusable: class { }

extension Reusable {
    public static var identifier:String {
        return String(describing: self)
    }
}

public protocol NibLoadableView: class { }

extension NibLoadableView where Self: UIView {
    public static var nibName: String {
        return String(describing: self)
    }
    
    public static func viewWithNib<T>(owner:AnyObject) -> T {
        let topLevelObjects = Bundle.main.loadNibNamed(self.nibName, owner: owner)
        return topLevelObjects?.first! as! T
    }
}
