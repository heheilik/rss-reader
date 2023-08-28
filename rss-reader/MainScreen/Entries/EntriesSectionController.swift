//
//  EntriesSectionController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 24.08.23.
//

import UIKit

class EntriesSectionController: NSObject {

    let viewModel = EntriesSectionViewModel()

    private let table: UITableView

    init(table: UITableView) {
        self.table = table
        super.init()
        viewModel.onFeedDownloaded = {
            DispatchQueue.main.sync {
                self.viewModel.updateFeedToPresent()
                self.table.reloadSections(
                    IndexSet(integer: TableSection.entries.rawValue),
                    with: .fade
                )
            }
        }
    }

}

extension EntriesSectionController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let typedSection = TableSection(rawValue: section) else {
            fatalError("Wrong section.")
        }

        // TODO: Move to ViewModel.
        switch typedSection {
        case .status:
            switch viewModel.entriesState {
            case .start, .loading:
                return 1
            case .showing:
                return 0
            }
        case .entries:
            switch viewModel.entriesState {
            case .showing:
                return viewModel.entryHeadersToPresent.count
            case .start, .loading:
                return 0
            }
        case .feedSources, .trashIcon:
            fatalError("Section \(typedSection) is not managed by this data source.")
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let typedSection = TableSection(rawValue: indexPath.section) else {
            fatalError("Wrong section.")
        }

        switch typedSection {
        case .status:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.statusScreen,
                for: indexPath
            ) as? StatusTableViewCell else {
                fatalError("Failed to dequeue \(CellIdentifier.statusScreen)")
            }
            switch viewModel.entriesState {
            case .start:
                cell.setStatus(.start)
            case .loading:
                cell.setStatus(.loading)
            case .showing:
                break
            }
            return cell

        case .entries:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.feedEntry,
                for: indexPath
            ) as? FeedEntryInfoTableViewCell else {
                fatalError("Failed to dequeue \(CellIdentifier.feedEntry)")
            }
            cell.updateContentsWith(viewModel.entryHeadersToPresent[indexPath.row])
            return cell

        case .feedSources, .trashIcon:
            fatalError("Section \(typedSection) is not managed by this data source.")
        }
    }

}

extension EntriesSectionController: FeedSourcesSelectionDelegate {

    func onCellSelectionArrayProbablyChanged(selectionArray: [IndexPath]) {
        viewModel.lastSelectionArray = selectionArray
        viewModel.prepareFeeds()
        viewModel.updateFeedToPresent()

        configureEntriesSections()
    }

    // TODO: Move to ViewModel.
    func configureEntriesSections() {
        guard !viewModel.lastSelectionArray.isEmpty else {
            changeEntriesSectionsState(to: .start)
            return
        }
        guard !viewModel.entryHeadersToPresent.isEmpty else {
            changeEntriesSectionsState(to: .loading)
            return
        }
        changeEntriesSectionsState(to: .showing)
    }

    func changeEntriesSectionsState(to newState: EntriesState) {
        table.performBatchUpdates {
            self.viewModel.entriesState = newState
            table.reloadSections(
                IndexSet([TableSection.status.rawValue, TableSection.entries.rawValue]),
                with: .fade
            )
        }
    }

}
