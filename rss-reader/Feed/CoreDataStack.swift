//
//  CoreDataStack.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 18.09.23.
//

import Foundation
import CoreData

final class CoreDataStack {

    enum DatabaseFileName {
        static let feed = "Feed.sql"
        static let feedSources = "FeedSources.sql"
    }

    let managedObjectModel: NSManagedObjectModel
    let storeCoordinator: NSPersistentStoreCoordinator

    private let rootContext: NSManagedObjectContext
    let mainThreadContext: NSManagedObjectContext

    init(modelUrl: URL, databaseFileName: String) {
        guard let model = NSManagedObjectModel(contentsOf: modelUrl) else {
            fatalError("Resource wasn't instantiated.")
        }
        managedObjectModel = model

        storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let fileURL = URL(string: databaseFileName, relativeTo: dirURL)
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

        rootContext = NSManagedObjectContext(.privateQueue)
        rootContext.persistentStoreCoordinator = storeCoordinator

        mainThreadContext = NSManagedObjectContext(.mainQueue)
        mainThreadContext.parent = rootContext
        mainThreadContext.mergePolicy = NSMergePolicy.overwrite
    }

    func save() {
        rootContext.perform {
            do {
                try self.rootContext.save()
            } catch {
                print("Failed to save changes to persistent store.")
            }
        }
    }

    func fetch(
        _ request: NSFetchRequest<NSFetchRequestResult>,
        completion: @escaping (NSFetchRequestResult?) -> Void
    ) {
        rootContext.perform {
            do {
                let result = try self.rootContext.fetch(request)
                completion(result as? NSFetchRequestResult)
            } catch {
                print(error)
                completion(nil)
            }
        }
    }

    func newChildContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(.privateQueue)
        context.parent = mainThreadContext
        return context
    }

}
