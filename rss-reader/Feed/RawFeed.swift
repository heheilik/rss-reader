//
//  RawFeed.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 24.07.23.
//

struct RawFeed {

    struct Header {
        let title: String
        let updated: String
        let id: String
    }

    let header: Header
    let entries: [RawEntry]

}

struct RawEntry {

    struct Header {
        let title: String
        let author: String
        let updated: String
        let id: String
    }

    let header: Header
    let content: String

}
