//
//  Entry+CoreDataProperties.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 28.08.23.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var author: String?
    @NSManaged public var content: String?
    @NSManaged public var identifier: String?
    @NSManaged public var lastUpdated: String?
    @NSManaged public var title: String?
    @NSManaged public var feed: Feed?

}

extension Entry : Identifiable {

}
