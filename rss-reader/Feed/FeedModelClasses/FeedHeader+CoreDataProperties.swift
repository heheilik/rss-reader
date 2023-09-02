//
//  FeedHeader+CoreDataProperties.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 3.09.23.
//

import Foundation
import CoreData


extension FeedHeader {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedHeader> {
        return NSFetchRequest<FeedHeader>(entityName: "FeedHeader")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var title: String?
    @NSManaged public var feed: Feed?

}

extension FeedHeader : Identifiable {

}
