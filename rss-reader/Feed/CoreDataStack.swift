//
//  CoreDataStack.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 18.09.23.
//

import Foundation
import CoreData

final class CoreDataStack {

    let managedObjectModel: NSManagedObjectModel
    let storeCoordinator: NSPersistentStoreCoordinator
    let primaryContext: NSManagedObjectContext

    init(modelUrl: URL, primaryContextConcurrencyType: NSManagedObjectContext.ConcurrencyType) {
        guard let model = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("Resource wasn't instantiated.")
        }
        managedObjectModel = model

        storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let fileURL = URL(string: "Feed.sql", relativeTo: dirURL)
        do {
            try storeCoordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: fileURL,
                options: nil
            )
        } catch {
            fatalError("Error configuring persistent store: \(error)")
        }

        primaryContext = NSManagedObjectContext(primaryContextConcurrencyType)
        primaryContext.persistentStoreCoordinator = storeCoordinator
    }

    func newChildContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = primaryContext
        return context
    }

}
