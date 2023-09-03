//
//  Entry+CoreDataProperties.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 3.09.23.
//

import Foundation
import CoreData

extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var content: String?
    @NSManaged public var feed: Feed?
    @NSManaged public var header: EntryHeader?

}

extension Entry : Identifiable {

}
