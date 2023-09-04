//
//  FeedServicesManager.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 31.08.23.
//

import Foundation
import CoreData

final class FeedServicesManager {

    var onFeedUpdated: (URL) -> Void = { _ in }

    private var feeds = [URL: Feed]()
    private var feedStates = [URL: FeedState]()

    private let feedHttpService = FeedHttpService()
    private let feedCoreDataService = FeedCoreDataService()

    func prepareFeed(withUrl url: URL) {
        feedStates[url] = FeedState()

        let asyncFetchRequest = NSAsynchronousFetchRequest<Feed>(
            fetchRequest: feedCoreDataService.fetchRequest(forUrl: url)
        ) { request in

            guard let feedStatus = self.feedStates[url] else {
                fatalError("Status is deleted")
            }

            let group = DispatchGroup()

            if let coreDataFeed = request.finalResult?.first {
                group.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
                    guard let feed = self.feedCoreDataService.insertIntoMainContext(
                        objectWithID: coreDataFeed.objectID
                    ) as? Feed else {
                        feedStatus.proceedCoreDataFetching(succeeded: false)
                        return
                    }

                    self.feeds[url] = feed
                    feedStatus.proceedCoreDataFetching(succeeded: true)
                    self.onFeedUpdated(url)
                }))
            } else {
                feedStatus.proceedCoreDataFetching(succeeded: false)
            }

            _ = self.feedHttpService.prepareFeed(withURL: url) { parsedFeed in
                group.notify(queue: DispatchQueue.main, work: DispatchWorkItem(block: {
                    guard let feedStatus = self.feedStates[url] else {
                        fatalError("Status is deleted.")
                    }

                    guard let parsedFeed else {
                        feedStatus.proceedHttpDownloading(succeeded: false)

                        switch feedStatus.state {
                        case .readyOldData:
                            self.onFeedUpdated(url)
                            print("Show that feed can't be updated.")

                        case .error:
                            print("Show error here.")

                        case .startedProcessing,
                             .coreDataFetchSucceded, .coreDataFetchFailed,
                             .httpDownloadSucceded,
                             .ready, .readyNotSaved:
                            break
                        }
                        return
                    }
                    feedStatus.proceedHttpDownloading(succeeded: true)

                    guard let coreDataFeed = self.feeds[url] else {
                        let coreDataFeed = self.feedCoreDataService.createFeed()
                        coreDataFeed.setData(from: parsedFeed, forUrl: url)
                        self.feeds[url] = coreDataFeed

                        let savingSucceded = self.feedCoreDataService.saveContext()
                        feedStatus.proceedCoreDataSaving(succeeded: savingSucceded)

                        self.onFeedUpdated(url)
                        return
                    }

                    guard coreDataFeed.header?.identifier == parsedFeed.header.identifier else {
                        self.feedCoreDataService.container.viewContext.delete(coreDataFeed)

                        let coreDataFeed = self.feedCoreDataService.createFeed()
                        coreDataFeed.setData(from: parsedFeed, forUrl: url)

                        let savingSucceded = self.feedCoreDataService.saveContext()
                        feedStatus.proceedCoreDataSaving(succeeded: savingSucceded)

                        self.onFeedUpdated(url)
                        return
                    }

                    feedStatus.proceedCoreDataSaving(succeeded: true)
                    self.onFeedUpdated(url)
                }))
            }
        }
        _ = try? feedCoreDataService.container.viewContext.execute(asyncFetchRequest)
    }

    func state(forFeedWithUrl url: URL) -> FeedState.State? {
        feedStates[url]?.state
    }

    func feed(withUrl url: URL) -> Feed? {
        feeds[url]
    }
}
