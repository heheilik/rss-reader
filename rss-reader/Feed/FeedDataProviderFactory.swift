//
//  FeedDataProviderFactory.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 25.09.23.
//

import Foundation
import CoreData

final class FeedDataProviderFactory {

    func newFeedDataProvider() -> FeedDataProvider {
        let coreDataStack = newCoreDataStack()
        let fetchedResultsController = newFetchedResultsController(coreDataStack: coreDataStack)
        let fetchPredicateTemplate = newPredicateTemplate()

        let feedHttpService = newFeedHttpService()

        return FeedDataProvider(
            coreDataStack: coreDataStack,
            fetchedResultsController: fetchedResultsController,
            fetchPredicateTemplate: fetchPredicateTemplate,
            feedHttpService: feedHttpService
        )
    }

    private func newCoreDataStack() -> CoreDataStack {
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

    private func newFetchedResultsController(
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

    private func newPredicateTemplate() -> NSPredicate {
        NSPredicate(
            format: "feed.url IN $lastUrlSet",
            argumentArray: []
        )
    }

    private func newFeedHttpService() -> FeedHttpService {
        FeedHttpService()
    }

}
