//
//  FeedViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 17.06.23.
//

import UIKit

class FeedViewController: UIViewController {
    
    private var viewModel = FeedViewModel()
    private var feedState = FeedScreenState()
    
    @IBOutlet weak var entriesTable: UITableView!
    
    enum CellIdentifier {
        static let feedsList = "FeedSourcesListTableViewCell"
        static let trashIcon = "TrashIconTableViewCell"
        static let feedEntry = "FeedEntryInfoTableViewCell"
    }
    
    private let trashImageDropDelegate = TrashImageDropDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entriesTable.dataSource = self
        entriesTable.delegate = self
        entriesTable.register(
            UINib(nibName: CellIdentifier.feedsList, bundle: nil),
            forCellReuseIdentifier: CellIdentifier.feedsList
        )
        entriesTable.register(
            UINib(nibName: CellIdentifier.trashIcon, bundle: nil),
            forCellReuseIdentifier: CellIdentifier.trashIcon
        )
        entriesTable.register(
            UINib(nibName: CellIdentifier.feedEntry, bundle: nil),
            forCellReuseIdentifier: CellIdentifier.feedEntry
        )
    }
    
}

extension FeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        feedState.numberOfSections
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let section = FeedScreenState.TableSection(
            index: section,
            isDeleteActive: feedState.isDeleteActive
        ) else {
            fatalError("Section \(section) is invalid.")
        }
        
        switch section {
        case .feedsList:
            return 1
        case .trashIcon:
            return 1
        case .feedEntries:
            return 0  // TODO: use DataSource here
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let section = FeedScreenState.TableSection(
            index: indexPath.section,
            isDeleteActive: feedState.isDeleteActive
        ) else {
            fatalError("Section \(indexPath.section) is invalid.")
        }
        
        switch section {
        case .feedsList:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.feedsList,
                for: indexPath
            ) as? FeedSourcesListTableViewCell else {
                fatalError("Failed to dequeue \(CellIdentifier.feedsList)")
            }
            return configureFeedsListCell(cell)
            
        case .trashIcon:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.trashIcon,
                for: indexPath
            ) as? TrashIconTableViewCell else {
                fatalError("Failed to dequeue \(CellIdentifier.trashIcon)")
            }
            return configureTrashIconCell(cell)
            
        case .feedEntries:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.feedEntry,
                for: indexPath
            ) as? FeedEntryInfoTableViewCell else {
                fatalError("Failed to dequeue \(CellIdentifier.feedEntry)")
            }
            return configureFeedEntryCell(cell)
        }
        
    }
    
    func configureFeedsListCell(_ cell: FeedSourcesListTableViewCell) -> FeedSourcesListTableViewCell {
        cell.viewController.onDragAndDropStarted = {
            self.entriesTable.performBatchUpdates {
                self.feedState.isDeleteActive = true
                self.entriesTable.insertSections(IndexSet(integer: 1), with: .top)
            }
        }
        cell.viewController.onDragAndDropFinished = {
            self.entriesTable.performBatchUpdates {
                self.feedState.isDeleteActive = false
                self.entriesTable.deleteSections(IndexSet(integer: 1), with: .top)
            }
        }
        trashImageDropDelegate.onDeleteDropSucceeded = cell.viewController.onDeleteDropSucceeded
        
        return cell
    }
    
    func configureTrashIconCell(_ cell: TrashIconTableViewCell) -> TrashIconTableViewCell {
        cell.trashImageDropDelegate = trashImageDropDelegate
        return cell
    }
    
    func configureFeedEntryCell(_ cell: FeedEntryInfoTableViewCell) -> FeedEntryInfoTableViewCell {
        let emptyEntry = Entry(
            title: "No data available.",
            author: "-",
            updated: "-",
            id: "-",
            content: ""
        )
        cell.updateContentsWith(emptyEntry)
        return cell
    }
    
}

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = FeedScreenState.TableSection(
            index: indexPath.section,
            isDeleteActive: feedState.isDeleteActive
        ) else {
            fatalError("Section \(indexPath.section) is invalid.")
        }
        
        switch section {
        case .feedsList:
            return TableSizeConstant.feedsListHeight + TableSizeConstant.sectionBottomInset
        case .trashIcon:
            return TableSizeConstant.trashIconHeight + TableSizeConstant.sectionBottomInset
        case .feedEntries:
            return 0  // TODO: make dynamic
        }
    }
    
}
