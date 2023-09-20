//
//  EntriesViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 5.09.23.
//

import Foundation
import CoreData

final class EntriesViewModel {

    private let coreDataStack: CoreDataStack
    private let fetchedResultsController: NSFetchedResultsController<Entry>

    private let feedHttpService = FeedHttpService()

    private var lastUrlSet = Set<URL>()
    private var feedIsBeingProcessed = [URL: Bool]()  // true or nil

    var updateUI: () -> Void = {}

    init() {
        guard let modelUrl = Bundle.main.url(
            forResource: "Feed",
            withExtension: "momd"
        ) else {
            fatalError("Resource wasn't found.")
        }
        coreDataStack = CoreDataStack(
            modelUrl: modelUrl,
            primaryContextConcurrencyType: .privateQueue
        )

        let fetchRequest = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "%K in %@",
            argumentArray: [#keyPath(Entry.feed.url), lastUrlSet]
        )
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Entry.lastUpdated, ascending: false)
        ]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataStack.primaryContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }

    func updateUrlSet(set: Set<URL>) {
        print("here")
        let newUrls = set.subtracting(lastUrlSet)
        lastUrlSet = set

        let separateContext = coreDataStack.newChildContext()
        separateContext.retainsRegisteredObjects = false
        separateContext.mergePolicy = NSMergePolicy.overwrite

        fetchedResultsController.managedObjectContext.perform {
            do {
                try self.fetchedResultsController.performFetch()
            } catch {
                print("Fetch failed.")
            }

            separateContext.perform {
                separateContext.refreshAllObjects()
            }
        }

        var urlsToDownload = Set<URL>()
        newUrls.forEach { url in
            guard feedIsBeingProcessed[url] != true else {
                return
            }
            urlsToDownload.insert(url)
            self.feedIsBeingProcessed[url] = true
        }

        var counter = urlsToDownload.count

        for url in urlsToDownload {
            self.feedHttpService.prepareFeed(withURL: url) { parsedFeed in
                separateContext.perform {
                    defer {
                        self.feedIsBeingProcessed[url] = nil

                        counter -= 1
                        if counter == 0 {
                            let primaryContext = self.coreDataStack.primaryContext
                            primaryContext.perform {
                                do {
                                    print(primaryContext.registeredObjects)
                                    try primaryContext.save()
                                    try self.fetchedResultsController.performFetch()
                                } catch {
                                    print(error)
                                }
                                print(primaryContext.registeredObjects)
                                print(self.fetchedResultsController.fetchedObjects?.count ?? "nil")
                            }
                        }
                    }

                    guard let parsedFeed else {
                        return
                    }

                    defer {
                        do {
                            try separateContext.save()
                        } catch {
                            print(error)
                        }
                    }

                    guard let feed = separateContext.registeredObjects.first(where: { object in
                        guard let feed = object as? Feed else {
                            return false
                        }
                        return feed.url == url
                    }) as? Feed else {
                        let feed = Feed(context: separateContext)
                        feed.setData(from: parsedFeed, forUrl: url)
                        return
                    }

                    guard feed.identifier == parsedFeed.header.identifier else {
                        feed.setData(from: parsedFeed, forUrl: url)
                        return
                    }
                }
            }
        }

    }

    // MARK: - Table State

    enum TableState {
        case start
        case loading
        case showing
    }

    private(set) var state: TableState = .start

    func reconfigureState() {
        guard !lastUrlSet.isEmpty else {
            state = .start
            return
        }
        state = .showing
    }

    func rowCount(for section: TableSection) -> Int {
        switch section {
        case .feedSourcesPlaceholder:
            return 1
        case .status:
            switch state {
            case .start:
                return 1
            case .loading:
                return 1
            case .showing:
                return 0
            }
        case .entries:
            switch state {
            case .start:
                return 0
            case .loading:
                return 0
            case .showing:
                return 0
            }
        }
    }

    // MARK: - Section

    enum TableSection: Int, CaseIterable {
        case feedSourcesPlaceholder
        case status
        case entries
    }

    func sectionCount() -> Int {
        TableSection.allCases.count
    }

    func section(forIndexPath indexPath: IndexPath) -> TableSection {
        guard let section = TableSection(rawValue: indexPath.section) else {
            fatalError("Section for cell at \(indexPath) does not exist.")
        }
        return section
    }

    func section(forIndex index: Int) -> TableSection {
        guard let section = TableSection(rawValue: index) else {
            fatalError("Section for index \(index) does not exist.")
        }
        return section
    }

}
