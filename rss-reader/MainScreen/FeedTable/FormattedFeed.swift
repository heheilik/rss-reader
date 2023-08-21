//
//  FormattedFeed.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 21.08.23.
//

import Foundation

struct FormattedFeed {
    
    struct Header {
        let title: String
        let updated: Date
        let id: String
    }
    
    let header: Header
    let entries: [FormattedEntry]
    
}

struct FormattedEntry {
    
    struct Header {
        let title: String
        let author: String
        let updated: Date
        let id: String
    }
    
    let header: Header
    let content: String
    
}
