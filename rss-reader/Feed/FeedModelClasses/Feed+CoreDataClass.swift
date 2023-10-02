//
//  Feed+CoreDataClass.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 20.09.23.
//

import Foundation
import CoreData

@objc(Feed)
public class Feed: NSManagedObject {

    func setData(from parsedFeed: ParsedFeed, forUrl url: URL) {

        guard let context = self.managedObjectContext else {
            fatalError("No context available.")
        }

        self.url = url

        self.identifier = parsedFeed.header.identifier.trimmingCharacters(in: .whitespacesAndNewlines)
        self.title = parsedFeed.header.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if let date = RFC3339DateFormatter().date(
            from: parsedFeed.header.lastUpdated.trimmingCharacters(in: .whitespacesAndNewlines)
        ) {
            self.lastUpdated = date
        }

        for parsedFeedEntry in parsedFeed.entries {
            let entry = Entry(context: context)
            entry.setData(from: parsedFeedEntry)
            entry.feed = self
            self.addToEntries(entry)
        }
    }

}
