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
    private var urlsLeftToDownload: Int {
        didSet {
            if urlsLeftToDownload == 0 {
                groupCompletion()
            }
        }
    }

    private var parsedFeedForUrl = [URL: ParsedFeed?]()

    var context: NSManagedObjectContext?

    let urlCompletion: (URL, ProcessingErrors) -> Void
    let groupCompletion: () -> Void

    struct ProcessingErrors: OptionSet {
        let rawValue: Int

        static let coreData        = ProcessingErrors(rawValue: 1 << 0)
        static let httpDownloading = ProcessingErrors(rawValue: 1 << 1)
    }

    init(
        feedHttpService: FeedHttpService,
        urlsToDownload: Set<URL>,
        urlCompletion: @escaping (URL, ProcessingErrors) -> Void,
        groupCompletion: @escaping () -> Void
    ) {
        self.feedHttpService = feedHttpService

        self.urlsToDownload = urlsToDownload
        self.urlsLeftToDownload = urlsToDownload.count

        self.urlCompletion = urlCompletion
        self.groupCompletion = groupCompletion
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

        context.perform { [self] in
            var errors = ProcessingErrors()

            defer {
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        print("Error saving child context. \(error)")
                        abort()
                    }
                }
                urlCompletion(url, errors)
                urlsLeftToDownload -= 1
            }

            guard
                let result = try? context.fetch(feedFetchRequest(for: url)),
                let feed = result.first
            else {
                guard let parsedFeed else {
                    errors = [.coreData, .httpDownloading]
                    return
                }

                let feed = Feed(context: context)
                feed.setData(from: parsedFeed, forUrl: url)
                return
            }

            if result.count > 1 {
                for index in 1..<result.count {
                    guard let entries = result[index].entries else {
                        context.delete(result[index])
                        continue
                    }
                    for entry in entries {
                        if let entry = entry as? NSManagedObject {
                            context.delete(entry)
                        }
                    }
                    context.delete(result[index])
                }
            }


            guard let parsedFeed else {
                errors.insert(.httpDownloading)
                return
            }

            guard feed.identifier != parsedFeed.header.identifier else {
                return
            }

            guard let entries = feed.entries else {
                feed.setData(from: parsedFeed, forUrl: url)
                return
            }
            for entry in entries {
                if let entry = entry as? NSManagedObject {
                    context.delete(entry)
                }
            }
            feed.setData(from: parsedFeed, forUrl: url)
        }
    }

    func startCompletionHandlers() {
        for (url, parsedFeed) in parsedFeedForUrl {
            urlCompletedLoading(url: url, parsedFeed: parsedFeed)
        }
    }

    func feedFetchRequest(for url: URL) -> NSFetchRequest<Feed> {
        let request = Feed.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K == %@",
            argumentArray: [#keyPath(Feed.url), url]
        )
        request.sortDescriptors = [NSSortDescriptor(
            keyPath: \Feed.lastUpdated,
            ascending: false
        )]
        return request
    }

}
