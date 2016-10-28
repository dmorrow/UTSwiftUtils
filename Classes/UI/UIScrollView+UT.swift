//
//  UIScrollView+UT.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 9, *)
extension UIScrollView {
    public func scrollToBottom(animated:Bool) {
        let bottomValue = max(0, (self.contentInset.top + self.contentInset.bottom) - self.frame.height + self.contentSize.height)
        let bottomOffset = CGPoint(x: 0, y: bottomValue)
        self.setContentOffset(bottomOffset, animated:animated)
    }
}
