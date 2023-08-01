//
//  Feed.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 24.07.23.
//

struct Feed {
    let title: String
    let updated: String
    let id: String
    let entry: [Entry]
}

struct Entry {
    let title: String
    let author: String
    let updated: String
    let id: String
    let content: String
}
