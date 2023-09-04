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

    typealias CellIdentifier = FeedViewController.CellIdentifier

    init(table: UITableView) {
        self.table = table

        super.init()

        viewModel.onFeedUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self else {
                    return
                }
                self.table.reloadSections(
                    IndexSet([TableSection.status.rawValue, TableSection.entries.rawValue]),
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
        return viewModel.rowCount(for: typedSection)
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
            case .none:
                cell.setStatus(.start)
            case .loading:
                cell.setStatus(.loading)
            case .error:
                cell.setStatus(.error)
            case .ready:
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
        viewModel.updateFeeds()

        table.reloadSections(
            IndexSet([TableSection.status.rawValue, TableSection.entries.rawValue]),
            with: .fade
        )
    }

}
