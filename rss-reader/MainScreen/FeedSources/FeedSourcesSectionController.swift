//
//  FeedSourcesSectionController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 27.08.23.
//

import UIKit

enum CellAppearance {
    static let cornerRadius: CGFloat = 5
    static let borderWidth: CGFloat = 3
    static let cellColor = UIColor.systemBlue
    static let cellColorSelected = UIColor.systemGray
    static let trashColor = UIColor.systemRed
}

class FeedSourcesSectionController: NSObject {

    private let table: UITableView

    init(table: UITableView) {
        self.table = table
        super.init()
        feedDragDropController.observers[self.dragDropObserverIdentifier] = self
    }

    // TODO: Move to ViewModel.
    var isDeleteActive = false

    let viewController = {
        let viewController = FeedSourcesCollectionViewController()
        UINib(
            nibName: "FeedSourcesViewController",
            bundle: nil
        ).instantiate(withOwner: viewController)
        return viewController
    }()
    let feedDragDropController = FeedDragDropController()

    func setSelectionDelegate(_ delegate: FeedSourcesSelectionDelegate) {
        viewController.selectionDelegate = delegate
    }

}

extension FeedSourcesSectionController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let typedSection = TableSection(rawValue: section) else {
            fatalError("Wrong section.")
        }

        switch typedSection {
        case .feedSources:
            return 1
        case .trashIcon:
            return isDeleteActive ? 1 : 0  // TODO: Move to ViewModel.
        case .status, .entries:
            fatalError("Section \(typedSection) is not managed by this data source.")
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let typedSection = TableSection(rawValue: indexPath.section) else {
            fatalError("Wrong section.")
        }

        switch typedSection {
        case .feedSources:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.feedsList,
                for: indexPath
            ) as? FeedSourcesListTableViewCell else {
                fatalError("Failed to dequeue \(CellIdentifier.feedsList)")
            }

            viewController.collectionView.dragDelegate = feedDragDropController
            viewController.collectionView.dropDelegate = feedDragDropController
            let identifier = viewController.dragDropObserverIdentifier
            feedDragDropController.observers[identifier] = viewController

            cell.viewController = viewController
            return cell

        case .trashIcon:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.trashIcon,
                for: indexPath
            ) as? TrashIconTableViewCell else {
                fatalError("Failed to dequeue \(CellIdentifier.trashIcon)")
            }
            cell.trashImageDropDelegate = feedDragDropController
            return cell

        case .status, .entries:
            fatalError("Section \(typedSection) is not managed by this data source.")
        }
    }

}

extension FeedSourcesSectionController: FeedDragDropObserver {

    var dragDropObserverIdentifier: String {
        "FeedSources"
    }

    func onDragDropStarted() {
        table.performBatchUpdates {
            self.isDeleteActive = true
            self.table.reloadSections(IndexSet(integer: TableSection.trashIcon.rawValue), with: .bottom)
        }
    }

    func onDragDropEnded() {
        table.performBatchUpdates {
            self.isDeleteActive = false
            self.table.reloadSections(IndexSet(integer: TableSection.trashIcon.rawValue), with: .top)
        }
    }

}
