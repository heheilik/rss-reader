//
//  ParsedFeed.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 29.08.23.
//

import Foundation

struct ParsedFeed {

    struct Header {
        let title: String
        let lastUpdated: String
        let identifier: String
    }

    let header: Header
    let entries: [ParsedEntry]

}

struct ParsedEntry {

    struct Header {
        let title: String
        let author: String
        let lastUpdated: String
        let identifier: String
    }

    let header: Header
    let content: String

}
