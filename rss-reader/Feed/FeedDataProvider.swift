//
//  FeedDataProvider.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 20.09.23.
//

import Foundation
import CoreData

class FeedDataProvider {

    private let coreDataStack: CoreDataStack
    private let fetchedResultsController: NSFetchedResultsController<Entry>

    private let feedHttpService: FeedHttpService

    private(set) var lastUrlSet = Set<URL>()
    private var feedIsBeingProcessed = [URL: Bool]()  // true or nil

    init(
        coreDataStack: CoreDataStack,
        fetchedResultsController: NSFetchedResultsController<Entry>,
        feedHttpService: FeedHttpService
    ) {
        self.coreDataStack = coreDataStack
        self.fetchedResultsController = fetchedResultsController
        self.feedHttpService = feedHttpService

        try? fetchedResultsController.performFetch()
    }

    func urlsToDownload(from currentUrlSet: Set<URL>) -> Set<URL> {
        let newUrls = currentUrlSet.subtracting(lastUrlSet)
        var result = Set<URL>()

        for url in newUrls {
            guard feedIsBeingProcessed[url] != true else {
                continue
            }
            result.insert(url)
        }

        return result
    }

    func updateUrlSet(with set: Set<URL>) {
        let urlsToDownload = urlsToDownload(from: set)
        urlsToDownload.forEach { url in
            feedIsBeingProcessed[url] = true
        }

        lastUrlSet = set

        let childContext = coreDataStack.newChildContext()
        childContext.retainsRegisteredObjects = false
        childContext.mergePolicy = NSMergePolicy.overwrite

        let feedGroupUpdater = FeedGroupUpdater(
            context: childContext,
            feedHttpService: feedHttpService,
            groupToUpdate: urlsToDownload,
            urlCompletion: urlCompletion,
            groupCompletion: groupCompletion
        )
        feedGroupUpdater.updateAndMerge()
    }

    func urlCompletion(_ url: URL, updatedWithoutErrors: Bool) {
        self.feedIsBeingProcessed[url] = nil
    }

    func groupCompletion(_ group: Set<URL>) {
        do {
            try coreDataStack.mainThreadContext.save()
        } catch {
            print(error)
        }
    }

}
