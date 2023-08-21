//
//  FeedViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 13.08.23.
//

import Foundation

class FeedViewModel {
    
    enum FeedStatus {
        case empty
        case loading
        case ready
    }
    
    private let feedService = FeedService()
    private var tasks: [URL: URLSessionDataTask] = [:]
    
    private var feeds: [URL: Feed?] = [:]
    private(set) var entryHeaders: [URL: [Entry.Header]] = [:]
    private(set) var feedStatuses: [URL: FeedStatus] = [:]
    
    private(set) var feedToPresent: [Entry.Header] = []
    
    var onFeedDownloaded: () -> Void = {}
    
    private func prepareFeed(forUrl url: URL) {
        feedStatuses[url] = .loading
        tasks[url] = feedService.prepareFeed(withURL: url) { feed in
            guard let feed else {
                self.tasks[url] = nil
                return
            }
            
            self.feeds[url] = feed
            var entryHeadersArray = [Entry.Header]()
            for entry in feed.entries {
                entryHeadersArray.append(entry.header)
            }
            self.entryHeaders[url] = entryHeadersArray
            
            self.feedStatuses[url] = .ready
            self.tasks[url] = nil
            
            self.onFeedDownloaded()
        }
    }
    
    func prepareFeeds(for selectionArray: [IndexPath]) {
        for indexPath in selectionArray {
            let index = indexPath.row
            let currentUrl = FeedURLDatabase.array[index].url
            
            if feedStatuses[currentUrl] == nil {
                feedStatuses[currentUrl] = .empty
            }
            let status = feedStatuses[currentUrl]!
            
            switch status {
            case .empty:
                prepareFeed(forUrl: currentUrl)
                break
            case .loading:
                break
            case .ready:
                break
            }
        }
    }
    
    func updateFeedToPresent(for selectionArray: [IndexPath]) {
        feedToPresent = []
        for indexPath in selectionArray {
            let index = indexPath.row
            let currentUrl = FeedURLDatabase.array[index].url
            guard let status = feedStatuses[currentUrl] else {
                continue
            }
            switch status {
            case .empty:
                break
            case .loading:
                break
            case .ready:
                feedToPresent.append(contentsOf: entryHeaders[currentUrl] ?? [])
            }
        }
    }
    
}
