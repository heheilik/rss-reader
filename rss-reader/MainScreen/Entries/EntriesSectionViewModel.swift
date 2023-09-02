//
//  EntriesSectionViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 24.08.23.
//

import Foundation
import CoreData

enum EntriesSectionState {
    case none
    case loading
    case error
    case ready
}

class EntriesSectionViewModel {

    // MARK: - Properties

    var entriesState = EntriesSectionState.none
    private(set) var entryHeadersToPresent: [EntryHeader] = []

    let feedServicesManager = FeedServicesManager()

    var onFeedUpdated: () -> Void = {}
    var lastSelectionArray = [IndexPath]()

    // MARK: - Initializer

    init() {
        feedServicesManager.onFeedUpdated = { [weak self] _ in
            guard let self else {
                return
            }
            updateFeedsToPresent()
            self.onFeedUpdated()
        }
    }

    func updateFeeds() {
        updateFeedsToPresent()
        reconfigureState()

        for indexPath in lastSelectionArray {
            let index = indexPath.row
            let currentUrl = FeedURLDatabase.array[index].url

            if feedServicesManager.state(forFeedWithUrl: currentUrl) == nil {
                feedServicesManager.prepareFeed(withUrl: currentUrl)
            }
        }
    }

    private func updateFeedsToPresent() {
        entryHeadersToPresent = []
        for indexPath in lastSelectionArray {
            let index = indexPath.row
            let currentUrl = FeedURLDatabase.array[index].url
            guard let state = feedServicesManager.state(forFeedWithUrl: currentUrl) else {
                continue
            }
            switch state {
            case .ready, .readyOldData, .readyNotSaved:
                guard let entries = feedServicesManager.feed(withUrl: currentUrl)?.entries?.allObjects else {
                    break
                }
                let headers = entries.compactMap({ entry in
                    return (entry as? Entry)?.header
                })
                entryHeadersToPresent.append(contentsOf: headers)

            case .startedProcessing,
                 .coreDataFetchFailed, .coreDataFetchSucceded,
                 .httpDownloadSucceded,
                 .error:
                break
            }
        }

        entryHeadersToPresent.sort(by: {
            guard let firstDate = $0.lastUpdated else {
                return false
            }
            guard let secondDate = $1.lastUpdated else {
                return true
            }
            return firstDate > secondDate
        })

        reconfigureState()
    }

    func reconfigureState() {
        guard !lastSelectionArray.isEmpty else {
            entriesState = .none
            return
        }
        guard !entryHeadersToPresent.isEmpty else {
            entriesState = .loading
            return
        }
        entriesState = .ready
    }

    func rowCount(for section: TableSection) -> Int {
        switch section {
        case .status:
            switch entriesState {
            case .none, .loading:
                return 1
            case .ready:
                return 0
            case .error:
                fatalError("Error state is not implemented.")
            }
        case .entries:
            switch entriesState {
            case .ready:
                return entryHeadersToPresent.count
            case .none, .loading:
                return 0
            case .error:
                fatalError("Error state is not implemented.")
            }
        case .feedSources, .trashIcon:
            fatalError("Section \(section) is not managed by this data source.")
        }
    }

}
