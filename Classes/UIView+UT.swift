//
//  UIView+UT.swift
//
//  Created by Daniel Morrow on 10/25/16.
//

import Foundation
import UIKit

@available(iOS 9, *)
extension UIView {
    
    public var viewController:UIViewController? {
        get {
            var next = self.superview
            while let safeNext = next {
                if let nextResponder = safeNext.next {
                    if let responder = nextResponder as? UIViewController {
                        return responder
                    }
                }
                next = safeNext.superview
            }
            return nil
        }
    }
    
    public func roundedCorners(_ corners:UIViewRoundedCornerMask, radius:CGFloat) {
        let rect = self.bounds
        let minx = rect.minX
        let midx = rect.midX
        let maxx = rect.maxX
        let miny = rect.minY
        let midy = rect.midY
        let maxy = rect.maxY
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: minx, y: midy))
        path.addArc(tangent1End: CGPoint(x: minx, y: miny), tangent2End: CGPoint(x: midx, y: miny), radius: corners.contains(UIViewRoundedCornerMask.upperLeft) ? radius : 0)
        
        path.addArc(tangent1End: CGPoint(x: maxx, y: miny), tangent2End: CGPoint(x: maxx, y: midy), radius: corners.contains(UIViewRoundedCornerMask.upperRight) ? radius : 0)
        path.addArc(tangent1End: CGPoint(x: maxx, y: maxy), tangent2End: CGPoint(x: midx, y: maxy), radius: corners.contains(UIViewRoundedCornerMask.lowerRight) ? radius : 0)
        path.addArc(tangent1End: CGPoint(x: minx, y: maxy), tangent2End: CGPoint(x: minx, y: midy), radius: corners.contains(UIViewRoundedCornerMask.lowerLeft) ? radius : 0)
        path.closeSubpath()
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        self.layer.mask = nil
        self.layer.mask = maskLayer
    }
}

public struct UIViewRoundedCornerMask : OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    
    public static var none: UIViewRoundedCornerMask        { return UIViewRoundedCornerMask(rawValue: 0) }
    public static var upperLeft: UIViewRoundedCornerMask   { return UIViewRoundedCornerMask(rawValue: 1 << 0) }
    public static var upperRight: UIViewRoundedCornerMask  { return UIViewRoundedCornerMask(rawValue: 1 << 1) }
    public static var lowerLeft: UIViewRoundedCornerMask   { return UIViewRoundedCornerMask(rawValue: 1 << 2) }
    public static var lowerRight: UIViewRoundedCornerMask  { return UIViewRoundedCornerMask(rawValue: 1 << 3) }
    public static var all: UIViewRoundedCornerMask         { return UIViewRoundedCornerMask(rawValue: (1 << 4)-1 ) }
}
