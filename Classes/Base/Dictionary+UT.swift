//
//  Dictionary+UT.swift
//  UTSwiftUtils
//
//  Created by Danny Morrow on 10/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func merge(_ dict: Dictionary<Key,Value>) -> Dictionary<Key,Value> {
        var mutableCopy = self
        for (key, value) in dict {
            mutableCopy[key] = value
        }
        return mutableCopy
    }
    
    static func + <K,V> (left: Dictionary<K,V>, right: Dictionary<K,V>?) -> Dictionary<K,V> {
        guard let right = right else { return left }
        return left.reduce(right) {
            var new = $0 as [K:V]
            new.updateValue($1.1, forKey: $1.0)
            return new
        }
    }
}
