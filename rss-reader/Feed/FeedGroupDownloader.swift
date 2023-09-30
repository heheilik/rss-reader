//
//  FeedGroupDownloader.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 29.09.23.
//

import Foundation
import CoreData

class FeedGroupDownloader {

    private let feedHttpService: FeedHttpService
    private let urlsToDownload: Set<URL>

    private var parsedFeedForUrl = [URL: ParsedFeed?]()

    var context: NSManagedObjectContext?

    // TODO: Add context save completion handler

    init(feedHttpService: FeedHttpService, urlsToDownload: Set<URL>) {
        self.feedHttpService = feedHttpService
        self.urlsToDownload = urlsToDownload
    }

    func download() {
        for url in urlsToDownload {
            feedHttpService.prepareFeed(withURL: url) { [self] parsedFeed in
                guard context != nil else {
                    parsedFeedForUrl[url] = parsedFeed
                    return
                }
                urlCompletedLoading(url: url, parsedFeed: parsedFeed)
            }
        }
    }

    func urlCompletedLoading(url: URL, parsedFeed: ParsedFeed?) {
        guard let context else {
            fatalError("Data processing started when context was unavailable.")
        }

        context.perform {
            defer {
                do {
                    if context.hasChanges {
                        try context.save()
                    }
                } catch {
                    print("Error saving child context. \(error)")
                }
            }

            guard let parsedFeed else {
                return
            }

            // TODO: get feed and entries with fetch request
            guard let feed = context.registeredObjects.first(where: { object in
                guard let feed = object as? Feed else {
                    return false
                }
                return feed.url == url
            }) as? Feed else {
                let feed = Feed(context: context)
                feed.setData(from: parsedFeed, forUrl: url)
                return
            }

            guard feed.identifier == parsedFeed.header.identifier else {
                feed.setData(from: parsedFeed, forUrl: url)
                return
            }

        }
    }

    func startCompletionHandlers() {
        for (url, parsedFeed) in parsedFeedForUrl {
            urlCompletedLoading(url: url, parsedFeed: parsedFeed)
        }
    }

}
