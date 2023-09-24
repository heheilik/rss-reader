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

    private let savingContext: NSManagedObjectContext
    let mainThreadContext: NSManagedObjectContext

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


        savingContext = NSManagedObjectContext(.privateQueue)
        savingContext.persistentStoreCoordinator = storeCoordinator

        mainThreadContext = NSManagedObjectContext(.mainQueue)
        mainThreadContext.parent = savingContext
        mainThreadContext.mergePolicy = NSMergePolicy.overwrite
    }

    func newChildContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(.privateQueue)
        context.parent = mainThreadContext
        return context
    }

    func save() {
        do {
            try mainThreadContext.save()
        } catch {
            print("Failed to save.")
        }
    }

}
