//
//  EntryHeader+CoreDataClass.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 3.09.23.
//

import Foundation
import CoreData

@objc(EntryHeader)
public class EntryHeader: NSManagedObject {

    func setData(from parsedEntryHeader: ParsedEntry.Header) {
        self.identifier = parsedEntryHeader.identifier
        self.title = parsedEntryHeader.title
        self.author = parsedEntryHeader.author
        if let date = RFC3339DateFormatter().date(from: parsedEntryHeader.lastUpdated) {
            self.lastUpdated = date
        }
    }

}
