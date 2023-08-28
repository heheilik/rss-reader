//
//  Entry+CoreDataClass.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 28.08.23.
//
//

import Foundation
import CoreData

@objc(Entry)
public class Entry: NSManagedObject {

    func setData(from rawEntry: RawEntry) {
        print("here")
        self.identifier = rawEntry.header.id
        self.title = rawEntry.header.title
        self.author = rawEntry.header.author
        self.lastUpdated = rawEntry.header.updated
        self.content = rawEntry.content
    }

}
