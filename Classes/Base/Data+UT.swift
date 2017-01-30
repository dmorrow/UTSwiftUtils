//
//  Data+UT.swift
//  UTSwiftUtils
//
//  Created by Danny Morrow on 1/19/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public extension Data {
    public var stringVal:String {
        var val: String = ""
        for i in 0..<self.count {
            val += String(format: "%02.2hhx", self[i] as CVarArg)
        }
        return val
    }
}
