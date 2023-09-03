//
//  Feed+CoreDataClass.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 3.09.23.
//

import Foundation
import CoreData

public class Feed: NSManagedObject {

    func setData(from parsedFeed: ParsedFeed, forUrl url: URL) {
        guard let context = self.managedObjectContext else {
            fatalError("No context available.")
        }

        self.url = url

        self.header = {
            let header = FeedHeader(context: context)
            header.setData(from: parsedFeed.header)
            header.feed = self
            return header
        }()

        for parsedFeedEntry in parsedFeed.entries {
            let entry = Entry(context: context)
            entry.setData(from: parsedFeedEntry)
            entry.feed = self
            self.addToEntries(entry)
        }
    }

}
