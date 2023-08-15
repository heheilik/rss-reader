//
//  FeedViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 13.08.23.
//

import Foundation

class FeedViewModel {
    
    private let feedService = FeedService()
    private(set) var feed: [Feed?] = []
    
    init() {
        feed = .init(repeating: nil, count: FeedURLDatabase.array.count)
    }
    
    func addNewFeed(name: String, url: URL) {
        FeedURLDatabase.array.append((name, url))
        feed.append(nil)
    }
    
}
