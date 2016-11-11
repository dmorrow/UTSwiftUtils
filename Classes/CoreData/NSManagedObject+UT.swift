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
    open class func fetchRequest<T:NSManagedObject>() -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: T.entityName);
    }
    
    open static func description(in context: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName, in: context)
    }
}
