//
//  EntriesSectionViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 24.08.23.
//

import Foundation
import CoreData

enum EntriesState {
    case start
    case loading
    case showing
}

enum FeedStatus {
    case empty
    case loading
    case ready
}

class EntriesSectionViewModel {

    var lastSelectionArray = [IndexPath]()

    var entriesState = EntriesState.start

    init() {
        container = NSPersistentContainer(name: "RawFeed")
        container.loadPersistentStores { _, _ in
            print("loaded")
        }
    }

    private let container: NSPersistentContainer

    private let feedService = FeedService()
    private var tasks: [URL: URLSessionDataTask] = [:]

    private var feeds: [URL: Feed] = [:]
    private(set) var entryHeaders: [URL: [FormattedEntry.Header]] = [:]
    private(set) var feedStatuses: [URL: FeedStatus] = [:]

    private(set) var entryHeadersToPresent: [FormattedEntry.Header] = []

    var onFeedDownloaded: () -> Void = {}

    private let feedFormatter = FeedFormatter()

    private func prepareFeed(forUrl url: URL) {
        feedStatuses[url] = .loading
        tasks[url] = feedService.prepareFeed(withURL: url) { feed in
            guard let feed else {
                self.tasks[url] = nil
                return
            }


            // writing to persistent store if needed
            let fetchRequest: NSFetchRequest<Feed> = Feed.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "%K == %@",
                #keyPath(Feed.urlString), url.absoluteString
            )
            DispatchQueue.main.async {
                do {
                    let result = try self.container.viewContext.fetch(fetchRequest)
                    guard result.isEmpty || result.first?.identifier != feed.header.id else {
                        print("data already exists")
                        return  // which means that data is here and it's the same
                    }

                    // trying to save new data
                    if !result.isEmpty {
                        self.container.viewContext.delete(result.first!)
                    }

                    let newEntity = Feed(context: self.container.viewContext)
                    newEntity.setData(from: feed, forUrl: url)

                    try self.container.viewContext.save()

                } catch {
                    print(error)
                }
            }

            var entryHeadersArray = [FormattedEntry.Header]()
            for entry in feed.entries {
                if let formattedEntry = self.feedFormatter.formattedEntry(from: entry) {
                    entryHeadersArray.append(formattedEntry.header)
                }
            }
            self.entryHeaders[url] = entryHeadersArray

            self.feedStatuses[url] = .ready
            self.tasks[url] = nil

            self.onFeedDownloaded()
        }
    }

    func prepareFeeds() {
        reconfigureState()

        for indexPath in lastSelectionArray {
            let index = indexPath.row
            let currentUrl = FeedURLDatabase.array[index].url

            if feedStatuses[currentUrl] == nil {
                feedStatuses[currentUrl] = .empty
            }
            let status = feedStatuses[currentUrl]!

            switch status {
            case .empty:
                prepareFeed(forUrl: currentUrl)
            case .loading:
                break
            case .ready:
                break
            }
        }
    }

    func updateFeedToPresent() {
        entryHeadersToPresent = []
        for indexPath in lastSelectionArray {
            let index = indexPath.row
            let currentUrl = FeedURLDatabase.array[index].url
            guard let status = feedStatuses[currentUrl] else {
                continue
            }
            switch status {
            case .empty:
                break
            case .loading:
                break
            case .ready:
                guard let headers = entryHeaders[currentUrl] else {
                    break
                }
                entryHeadersToPresent.append(contentsOf: headers)
            }
        }

        entryHeadersToPresent.sort(by: { $0.updated > $1.updated })

        reconfigureState()
    }

    func reconfigureState() {
        guard !lastSelectionArray.isEmpty else {
            entriesState = .start
            return
        }
        guard !entryHeadersToPresent.isEmpty else {
            entriesState = .loading
            return
        }
        entriesState = .showing
    }

    func rowCount(for section: TableSection) -> Int {
        switch section {
        case .status:
            switch entriesState {
            case .start, .loading:
                return 1
            case .showing:
                return 0
            }
        case .entries:
            switch entriesState {
            case .showing:
                return entryHeadersToPresent.count
            case .start, .loading:
                return 0
            }
        case .feedSources, .trashIcon:
            fatalError("Section \(section) is not managed by this data source.")
        }
    }

}
