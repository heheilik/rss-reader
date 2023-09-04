//
//  FeedState.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 1.09.23.
//

import Foundation

class FeedState {

    enum State {
        // First step.
        case startedProcessing

        // Second step.
        case coreDataFetchSucceded
        case coreDataFetchFailed

        // Third step.
        case httpDownloadSucceded

        // End state.
        case error
        case readyNotSaved
        case readyOldData
        case ready
    }

    private(set) var state: State

    init() {
        state = .startedProcessing
        print(state)
    }

    func proceedCoreDataFetching(succeeded: Bool) {
        switch state {
        case .startedProcessing:
            state = succeeded ? .coreDataFetchSucceded : .coreDataFetchFailed

        case .coreDataFetchSucceded, .coreDataFetchFailed:
            fatalError("Wrong state for \"Core Data Fetching\" step.")

        case .httpDownloadSucceded:
            fatalError("Wrong state for \"Core Data Fetching\" step.")

        case .error, .readyNotSaved, .readyOldData, .ready:
            fatalError("Final step can't be proceeded.")
        }
        print(state)
    }

    func proceedHttpDownloading(succeeded: Bool) {
        switch state {
        case .startedProcessing:
            fatalError("Wrong state for \"HTTP Downloading\" step.")

        case .coreDataFetchSucceded:
            state = succeeded ? .httpDownloadSucceded : .readyOldData

        case .coreDataFetchFailed:
            state = succeeded ? .httpDownloadSucceded : .error

        case .httpDownloadSucceded:
            fatalError("Wrong state for \"HTTP Downloading\" step.")

        case .error, .readyNotSaved, .readyOldData, .ready:
            fatalError("Final step can't be proceeded.")
        }
        print(state)
    }

    func proceedCoreDataSaving(succeeded: Bool) {
        switch state {
        case .startedProcessing:
            fatalError("Wrong state for \"Core Data Saving\" step.")

        case .coreDataFetchSucceded, .coreDataFetchFailed:
            fatalError("Wrong state for \"Core Data Saving\" step.")

        case .httpDownloadSucceded:
            state = succeeded ? .ready : .readyNotSaved

        case .error, .readyNotSaved, .readyOldData, .ready:
            fatalError("Final step can't be proceeded.")
        }
        print(state)
    }

}
