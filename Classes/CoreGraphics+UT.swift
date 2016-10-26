//
//  CoreGraphics+UT.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGFloat {
    public var sign:Int {
        if self < 0.0 {
            return -1
        } else if self ==  0 {
            return 0
        } else {
            return 1
        }
    }
}

@available(iOS 9, *)
extension CGPoint {
    public subscript(xy:String) -> CGFloat {
        get {
            switch xy {
            case "x":
                return self.x
            case "y":
                return self.y
            default:
                assertionFailure("CGPoint can only get x and y!")
                return CGFloat.greatestFiniteMagnitude
            }
        }
        set {
            switch xy {
            case "x":
                self.x = newValue
            case "y":
                self.y = newValue
            default:
                assertionFailure("CGPoint can only set x and y!")
            }
        }

    }
}
