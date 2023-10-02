//
//  EntriesViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 5.09.23.
//

import Foundation
import CoreData

final class EntriesViewModel {

    let feedDataProvider: FeedDataProvider

    init() {
        feedDataProvider = FeedDataProviderFactory().newFeedDataProvider()
        feedDataProvider.dataChangedCallback = { [weak self] in
            if let self {
                self.reconfigureState()
                print(state)
            }
        }
    }

    var dataChangedCallback: () -> Void = {}

    func updateUrlSet(with set: Set<URL>) {
        feedDataProvider.updateUrlSet(with: set)
    }

    // MARK: - Table State

    enum TableState {
        case start
        case loading
        case showing
    }

    private(set) var state: TableState = .start

    func reconfigureState() {
        defer {
            dataChangedCallback()
        }

        guard !feedDataProvider.lastUrlSet.isEmpty else {
            state = .start
            return
        }
        guard
            let fetchedObjects = feedDataProvider.fetchedResultsController.fetchedObjects,
            fetchedObjects.count != 0
        else {
            state = .loading
            return
        }
        state = .showing
    }

    func rowCount(for section: TableSection) -> Int {
        switch section {
        case .feedSourcesPlaceholder:
            return 1
        case .status:
            switch state {
            case .start:
                return 1
            case .loading:
                return 1
            case .showing:
                return 0
            }
        case .entries:
            switch state {
            case .start:
                return 0
            case .loading:
                return 0
            case .showing:
                return feedDataProvider.fetchedResultsController.fetchedObjects?.count ?? 0
            }
        }
    }

    // MARK: - Section

    enum TableSection: Int, CaseIterable {
        case feedSourcesPlaceholder
        case status
        case entries
    }

    func sectionCount() -> Int {
        TableSection.allCases.count
    }

    func section(forIndexPath indexPath: IndexPath) -> TableSection {
        guard let section = TableSection(rawValue: indexPath.section) else {
            fatalError("Section for cell at \(indexPath) does not exist.")
        }
        return section
    }

    func section(forIndex index: Int) -> TableSection {
        guard let section = TableSection(rawValue: index) else {
            fatalError("Section for index \(index) does not exist.")
        }
        return section
    }

}
