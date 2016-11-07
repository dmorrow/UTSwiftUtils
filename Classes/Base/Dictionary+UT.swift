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
    
    static func + <Key:Hashable,Value:Any> (left: Dictionary<Key,Value>, right: Dictionary<Key,Value>?) -> Dictionary<Key,Value> {
        guard let right = right else { return left }
        return left.reduce(right) {
            var new = $0
            new.updateValue($1.1, forKey: $1.0)
            return new
        }
    }
    
    static func += <Key:Hashable,Value:Any> ( left: inout Dictionary<Key,Value>, right: Dictionary<Key,Value>) {
        for (k,v) in right {
            left.updateValue(v, forKey: k)
            return
        } 
    }
}
