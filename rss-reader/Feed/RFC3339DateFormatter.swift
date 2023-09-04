//
//  RFC3339DateFormatter.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 29.08.23.
//

import Foundation

struct RFC3339DateFormatter {

    private let dateFormatter: DateFormatter

    init() {
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    }

    func date(from string: String) -> Date? {
        dateFormatter.date(from: string)
    }

}