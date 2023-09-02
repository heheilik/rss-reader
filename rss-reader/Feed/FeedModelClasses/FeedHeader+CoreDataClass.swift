//
//  FeedHeader+CoreDataClass.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 3.09.23.
//

import Foundation
import CoreData

@objc(FeedHeader)
public class FeedHeader: NSManagedObject {

    func setData(from parsedFeedHeader: ParsedFeed.Header) {
        self.identifier = parsedFeedHeader.identifier
        self.title = parsedFeedHeader.title
        if let date = RFC3339DateFormatter().date(from: parsedFeedHeader.lastUpdated) {
            self.lastUpdated = date
        }
    }

}
