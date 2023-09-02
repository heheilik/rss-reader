//
//  Entry+CoreDataClass.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 3.09.23.
//

import Foundation
import CoreData


public class Entry: NSManagedObject {

    func setData(from parsedEntry: ParsedEntry) {
        guard let context = self.managedObjectContext else {
            fatalError("No context available.")
        }

        self.header = {
            let header = EntryHeader(context: context)
            header.setData(from: parsedEntry.header)
            header.entry = self
            return header
        }()
        self.content = parsedEntry.content
    }

}
