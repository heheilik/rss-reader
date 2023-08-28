//
//  EntriesSectionViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 24.08.23.
//

import Foundation

enum EntriesState {
    case start
    case loading
    case showing
}

enum FeedStatus {
    case empty
    case loading
    case ready
}

class EntriesSectionViewModel {

    var lastSelectionArray = [IndexPath]()

    var entriesState = EntriesState.start

    private let feedService = FeedService()
    private var tasks: [URL: URLSessionDataTask] = [:]

    private var feeds: [URL: RawFeed?] = [:]
    private(set) var entryHeaders: [URL: [FormattedEntry.Header]] = [:]
    private(set) var feedStatuses: [URL: FeedStatus] = [:]

    private(set) var entryHeadersToPresent: [FormattedEntry.Header] = []

    var onFeedDownloaded: () -> Void = {}

    private let feedFormatter = FeedFormatter()

    private func prepareFeed(forUrl url: URL) {
        feedStatuses[url] = .loading
        tasks[url] = feedService.prepareFeed(withURL: url) { feed in
            guard let feed else {
                self.tasks[url] = nil
                return
            }

            self.feeds[url] = feed

            var entryHeadersArray = [FormattedEntry.Header]()
            for entry in feed.entries {
                if let formattedEntry = self.feedFormatter.formattedEntry(from: entry) {
                    entryHeadersArray.append(formattedEntry.header)
                }
            }
            self.entryHeaders[url] = entryHeadersArray

            self.feedStatuses[url] = .ready
            self.tasks[url] = nil

            self.onFeedDownloaded()
        }
    }

    func prepareFeeds() {
        for indexPath in lastSelectionArray {
            let index = indexPath.row
            let currentUrl = FeedURLDatabase.array[index].url

            if feedStatuses[currentUrl] == nil {
                feedStatuses[currentUrl] = .empty
            }
            let status = feedStatuses[currentUrl]!

            switch status {
            case .empty:
                prepareFeed(forUrl: currentUrl)
            case .loading:
                break
            case .ready:
                break
            }
        }
    }

    func updateFeedToPresent() {
        entryHeadersToPresent = []
        for indexPath in lastSelectionArray {
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
                guard let headers = entryHeaders[currentUrl] else {
                    break
                }
                entryHeadersToPresent.append(contentsOf: headers)
            }
        }

        entryHeadersToPresent.sort(by: { $0.updated > $1.updated })
    }

}
