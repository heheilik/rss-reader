//
//  Feed+CoreDataProperties.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 28.08.23.
//
//

import Foundation
import CoreData


extension Feed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
        return NSFetchRequest<Feed>(entityName: "Feed")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var lastUpdated: String?
    @NSManaged public var title: String?
    @NSManaged public var urlString: String?
    @NSManaged public var entries: NSSet?

}

// MARK: Generated accessors for entries
extension Feed {

    @objc(addEntriesObject:)
    @NSManaged public func addToEntries(_ value: Entry)

    @objc(removeEntriesObject:)
    @NSManaged public func removeFromEntries(_ value: Entry)

    @objc(addEntries:)
    @NSManaged public func addToEntries(_ values: NSSet)

    @objc(removeEntries:)
    @NSManaged public func removeFromEntries(_ values: NSSet)

}

extension Feed : Identifiable {

}
