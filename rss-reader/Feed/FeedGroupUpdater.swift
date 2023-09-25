//
//  FeedGroupUpdater.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 24.09.23.
//

import Foundation
import CoreData

final class FeedGroupUpdater {

    let context: NSManagedObjectContext
    let feedHttpService: FeedHttpService

    let groupToUpdate: Set<URL>

    let urlCompletion: (URL, Bool) -> Void
    let groupCompletion: (Set<URL>) -> Void

    init(
        context: NSManagedObjectContext,
        feedHttpService: FeedHttpService,
        groupToUpdate: Set<URL>,
        urlCompletion: @escaping (URL, Bool) -> Void,
        groupCompletion: @escaping (Set<URL>) -> Void
    ) {
        self.context = context
        self.feedHttpService = feedHttpService
        self.groupToUpdate = groupToUpdate
        self.urlCompletion = urlCompletion
        self.groupCompletion = groupCompletion
    }

    func updateAndMerge() {
        var counter = groupToUpdate.count

        for url in groupToUpdate {
            self.feedHttpService.prepareFeed(withURL: url) { parsedFeed in
                self.context.perform { [self] in
                    var updatedWithoutErrors = true

                    defer {
                        if context.hasChanges {
                            do {
                                try context.save()
                            } catch {
                                print(error)
                            }
                        }
                        urlCompletion(url, updatedWithoutErrors)
                    }

                    defer {
                        counter -= 1
                        if counter == 0 {
                            groupCompletion(groupToUpdate)
                        }
                    }

                    guard let parsedFeed else {
                        updatedWithoutErrors = false
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
        }

    }

}
