//
//  FeedSource.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 16.08.23.
//

import Foundation

struct FeedSource {
    let name: String
    let url: URL
}

extension FeedSource: Equatable {}
