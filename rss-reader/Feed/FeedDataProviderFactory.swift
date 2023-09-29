//
//  FeedDataProviderFactory.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 25.09.23.
//

import Foundation
import CoreData

final class FeedDataProviderFactory {

    func createFeedDataProvider() -> FeedDataProvider {
        let coreDataStack = createCoreDataStack()
        let fetchedResultsController = createFetchedResultsController(coreDataStack: coreDataStack)
        let fetchPredicateTemplate = fetchPredicateTemplate()

        let feedHttpService = createFeedHttpService()

        return FeedDataProvider(
            coreDataStack: coreDataStack,
            fetchedResultsController: fetchedResultsController,
            fetchPredicateTemplate: fetchPredicateTemplate,
            feedHttpService: feedHttpService
        )
    }

    private func createCoreDataStack() -> CoreDataStack {
        guard let modelUrl = Bundle.main.url(
            forResource: "Feed",
            withExtension: "momd"
        ) else {
            fatalError("Resource wasn't found.")
        }
        return CoreDataStack(
            modelUrl: modelUrl,
            databaseFileName: CoreDataStack.DatabaseFileName.feed
        )
    }

    private func createFetchedResultsController(
        coreDataStack: CoreDataStack
    ) -> NSFetchedResultsController<Entry> {

        let fetchRequest = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "FALSEPREDICATE", argumentArray: [])
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Entry.lastUpdated, ascending: false)
        ]

        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.mainThreadContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }

    private func fetchPredicateTemplate() -> NSPredicate {
        return NSPredicate(
            format: "feed.url IN $lastUrlSet",
            argumentArray: []
        )
    }

    private func createFeedHttpService() -> FeedHttpService {
        return FeedHttpService()
    }

}
