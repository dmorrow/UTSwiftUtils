//
//  NSObject+UT.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation

extension NSObject {
    public typealias cancellable_closure = (() -> ())?
    
    @discardableResult
    public func delay(_ delay:TimeInterval, closure:@escaping ()->()) -> cancellable_closure{
        
        var cancelled = false
        let cancel_closure: cancellable_closure = {
            cancelled = true
        }
        
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + delay, execute: {
                if !cancelled {
                    closure()
                }
            }
        )
        
        return cancel_closure
    }
    
    public func cancel_delay(_ cancel_closure: cancellable_closure?) {
        if let closure = cancel_closure {
            closure?()
        }
        
    }
}
