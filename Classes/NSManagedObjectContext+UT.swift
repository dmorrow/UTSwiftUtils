//
//  NSManagedObjectContext+UT.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright © 2016 unitytheory. All rights reserved.
//

import Foundation
import CoreData

//http://collindonnell.com/2015/07/22/swift-delete-all-objects-extension/

extension NSManagedObjectContext {
       
    public convenience init(parentContext parent: NSManagedObjectContext, concurrencyType: NSManagedObjectContextConcurrencyType) {
        self.init(concurrencyType: concurrencyType)
        self.parent = parent
    }
    
    public func deleteAllObjects() throws {
        
        if let coordinator = persistentStoreCoordinator {
            let entitesByName = coordinator.managedObjectModel.entitiesByName
            for (_, entityDescription) in entitesByName {
                do {
                    try deleteAllObjects(for: entityDescription)
                } catch let error as NSError{
                    throw error
                }
            }
        }
    }
    
    public func deleteAllObjects(for entity: NSEntityDescription) throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 50
        
        let fetchResults:[AnyObject]?
        do {
            fetchResults = try fetch(fetchRequest)
        } catch let error as NSError{
            throw error
        }
        
        if let managedObjects = fetchResults as? [NSManagedObject] {
            for object in managedObjects {
                delete(object)
            }
            do {
                try save()
            } catch let error as NSError{
                throw error
            }
        }
        
    }
}
