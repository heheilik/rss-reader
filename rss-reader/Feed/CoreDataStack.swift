//
//  CoreDataStack.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 18.09.23.
//

import Foundation
import CoreData

class CoreDataStack {

    let managedObjectModel: NSManagedObjectModel
    let storeCoordinator: NSPersistentStoreCoordinator
    let mainContext: NSManagedObjectContext

    init() {
        guard let modelUrl = Bundle.main.url(
            forResource: "Feed",
            withExtension: "momd"
        ) else {
            fatalError("Resource wasn't found.")
        }
        guard let model = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("Resource wasn't instantiated.")
        }
        managedObjectModel = model

        storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = storeCoordinator
    }

}
