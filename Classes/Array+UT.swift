//
//  Array+UT.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation
extension Array where Element: Equatable {
    
    public func uniq() -> [Element] {
        var arrayCopy = self
        arrayCopy.uniqInPlace()
        return arrayCopy
    }
    
    mutating public func uniqInPlace() {
        var seen = [Element]()
        var index = 0
        for element in self {
            if seen.contains(element) {
                remove(at: index)
            } else {
                seen.append(element)
                index += 1
            }
        }
    }
    
    public subscript(back i: Int) -> Element {
        return self.reversed()[i]
    }
}
