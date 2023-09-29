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

    private var completionHandlers = [(ParsedFeed?) -> Void]()
    private var parsedFeedsForCompletionHandlers = [ParsedFeed?]()

    var context: NSManagedObjectContext?

    init(feedHttpService: FeedHttpService, urlsToDownload: Set<URL>) {
        self.feedHttpService = feedHttpService
        self.urlsToDownload = urlsToDownload
    }

    func download() {
        for url in urlsToDownload {
            feedHttpService.prepareFeed(withURL: url) { [self] parsedFeed in
                // FIXME: Strong reference cycle!!!
                let completionHandler: (ParsedFeed?) -> Void = { [self] parsedFeed in
//                    guard let strongSelf = self else {
//                        return
//                    }
//                    guard let context = strongSelf.context else {
//                        fatalError("Data processing started when context was unavailable.")
//                    }
                    guard let context = self.context else {
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

                if self.context != nil {
                    completionHandler(parsedFeed)
                } else {
                    self.parsedFeedsForCompletionHandlers.append(parsedFeed)
                    self.completionHandlers.append(completionHandler)
                }
            }
        }
    }

    func startCompletionHandlers() {
        for index in completionHandlers.indices {
            completionHandlers[index](parsedFeedsForCompletionHandlers[index])
        }
    }

}
