//
//  Feed.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 24.07.23.
//

struct Feed {
    
    struct Header {
        let title: String
        let updated: String
        let id: String
    }
    
    let header: Header
    let entry: [Entry]
    
}

struct Entry {
    
    struct Header {
        let title: String
        let author: String
        let updated: String
        let id: String
    }
    
    let header: Header
    let content: String
    
}
