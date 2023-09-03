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
        self.identifier = parsedEntryHeader.identifier.trimmingCharacters(in: .whitespacesAndNewlines)
        self.title = parsedEntryHeader.title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.author = parsedEntryHeader.author.trimmingCharacters(in: .whitespacesAndNewlines)
        if let date = RFC3339DateFormatter().date(
            from: parsedEntryHeader.lastUpdated.trimmingCharacters(in: .whitespacesAndNewlines)
        ) {
            self.lastUpdated = date
        }
    }

}
