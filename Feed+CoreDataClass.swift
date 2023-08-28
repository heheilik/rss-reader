//
//  Feed+CoreDataClass.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 28.08.23.
//
//

import Foundation
import CoreData

@objc(Feed)
public class Feed: NSManagedObject {

    func setData(from rawFeed: RawFeed, forUrl url: URL) {
        guard let context = self.managedObjectContext else {
            fatalError("No context available.")
        }

        self.urlString = url.absoluteString

        self.title = rawFeed.header.title
        self.identifier = rawFeed.header.id
        self.lastUpdated = rawFeed.header.updated

        for entry in rawFeed.entries {
            let coreDataEntry = Entry(context: context)
            coreDataEntry.setData(from: entry)
            self.addToEntries(coreDataEntry)
        }
    }

}
