//
//  FeedFormatter.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 21.08.23.
//

import Foundation

struct FeedFormatter {
    
    private let dateFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    }
    
    func formattedEntryHeader(from rawEntryHeader: RawEntry.Header) -> FormattedEntry.Header? {
        fatalError("formattedEntryHeader(rawEntryHeader:) not implemented")
    }
    
    func formattedEntry(from rawEntry: RawEntry) -> FormattedEntry? {
        guard let date = dateFormatter.date(from: rawEntry.header.updated) else {
            return nil
        }
        return FormattedEntry(
            header: FormattedEntry.Header(
                title: rawEntry.header.title.trimmingCharacters(in: .whitespacesAndNewlines),
                author: rawEntry.header.author.trimmingCharacters(in: .whitespacesAndNewlines),
                updated: date,
                id: rawEntry.header.id.trimmingCharacters(in: .whitespacesAndNewlines)
            ),
            content: rawEntry.content
        )
    }
    
    func formattedFeedHeader(from rawFeedHeader: RawFeed.Header) -> FormattedFeed.Header? {
        fatalError("formattedFeedHeader(rawFeedHeader:) not implemented")
    }
    
    func formattedFeed(from rawFeed: RawFeed) -> FormattedFeed? {
        fatalError("formattedFeed(rawFeed:) not implemented")
    }
    
    private func date(from string: String) -> Date? {
        dateFormatter.date(from: string)
    }
    
}
