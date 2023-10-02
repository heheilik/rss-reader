//
//  Entry+CoreDataClass.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 20.09.23.
//

import Foundation
import CoreData

@objc(Entry)
public class Entry: NSManagedObject {

    func setData(from parsedEntry: ParsedEntry) {
        self.identifier = parsedEntry.header.identifier.trimmingCharacters(in: .whitespacesAndNewlines)
        self.title = parsedEntry.header.title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.author = parsedEntry.header.author.trimmingCharacters(in: .whitespacesAndNewlines)
        if let date = RFC3339DateFormatter().date(
            from: parsedEntry.header.lastUpdated.trimmingCharacters(in: .whitespacesAndNewlines)
        ) {
            self.lastUpdated = date
        }

        self.content = parsedEntry.content
    }

}
