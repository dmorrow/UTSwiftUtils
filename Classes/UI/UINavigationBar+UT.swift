//
//  UINavigationBar+UT.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9, *)
extension UINavigationBar {
    
    public func hideRule() {
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.shadowImage = UIImage()
    }
    
    public func showRule() {
        self.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.shadowImage = nil
    }
}
