//
//  FeedCoreDataService.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 31.08.23.
//

import Foundation
import CoreData

final class FeedCoreDataService {

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Feed")
        container.loadPersistentStores { _, _ in }
    }

    func fetchRequest(forUrl url: URL) -> NSFetchRequest<Feed> {
        let fetchRequest: NSFetchRequest<Feed> = Feed.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K == %@",
            argumentArray: [#keyPath(Feed.url), url]
        )
        return fetchRequest
    }

    // TODO: Use generics.
    func createFeed() -> Feed {
        Feed(context: container.viewContext)
    }

    func insertIntoMainContext(objectWithID id: NSManagedObjectID) -> NSManagedObject {
        container.viewContext.object(with: id)
    }

    func saveContext() -> Bool {
        do {
            try container.viewContext.save()
        } catch {
            return false
        }
        return true
    }

}
