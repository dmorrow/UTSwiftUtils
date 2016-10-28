//
//  NSManagedObject+UT.swift
//  UTSwiftUtils
//
//  Created by Danny Morrow on 10/26/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    open static var entityName:String {
        return String(describing: self)
    }
}
