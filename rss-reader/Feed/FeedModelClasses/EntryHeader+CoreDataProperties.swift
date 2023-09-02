//
//  EntryHeader+CoreDataProperties.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 3.09.23.
//

import Foundation
import CoreData


extension EntryHeader {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntryHeader> {
        return NSFetchRequest<EntryHeader>(entityName: "EntryHeader")
    }

    @NSManaged public var author: String?
    @NSManaged public var identifier: String?
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var title: String?
    @NSManaged public var entry: Entry?

}

extension EntryHeader : Identifiable {

}
