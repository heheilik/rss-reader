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
    private let fetchPredicateTemplate: NSPredicate

    private let feedHttpService: FeedHttpService

    private(set) var lastUrlSet = Set<URL>()
    private var feedIsBeingProcessed = [URL: Bool]()  // true or nil

    init(
        coreDataStack: CoreDataStack,
        fetchedResultsController: NSFetchedResultsController<Entry>,
        fetchPredicateTemplate: NSPredicate,
        feedHttpService: FeedHttpService
    ) {
        self.coreDataStack = coreDataStack
        self.fetchedResultsController = fetchedResultsController
        self.fetchPredicateTemplate = fetchPredicateTemplate
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

        let groupDownloader = FeedGroupDownloader(
            feedHttpService: feedHttpService,
            urlsToDownload: urlsToDownload
        )
        groupDownloader.urlCompletion = { url, errors in
            self.feedIsBeingProcessed[url] = nil
        }

        groupDownloader.download()

        fetchedResultsController.fetchRequest.predicate =
            fetchPredicateTemplate.withSubstitutionVariables(["lastUrlSet": lastUrlSet])

        guard let fetchRequest =
            fetchedResultsController.fetchRequest as? NSFetchRequest<NSFetchRequestResult>
        else {
            fatalError("Failed to cast fetchRequest.")
        }

        coreDataStack.fetch(fetchRequest) { _ in
            DispatchQueue.main.async { [self] in
                do {
                    try fetchedResultsController.performFetch()
                    print(fetchedResultsController.fetchedObjects?.count ?? "nil")
                } catch {
                    print("fetchedResultsController failed to perform fetch.")
                }
                let childContext = coreDataStack.newChildContext()
                groupDownloader.context = childContext
                groupDownloader.startCompletionHandlers()
            }
        }
    }

}
