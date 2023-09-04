//
//  FeedViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 17.06.23.
//

import UIKit

enum TableSection: Int, CaseIterable {
    case feedSources = 0
    case trashIcon
    case status
    case entries
}

class FeedViewController: UIViewController {

    private let viewModel = FeedViewModel()

    private var feedSourcesController: FeedSourcesSectionController!
    private var entriesController: EntriesSectionController!

    private weak var feedSourcesSectionDataSource: UITableViewDataSource?
    private weak var entriesSectionDataSource: UITableViewDataSource?

    @IBOutlet weak var table: UITableView!

    enum CellIdentifier {
        static let feedsList = "FeedSourcesListTableViewCell"
        static let trashIcon = "TrashIconTableViewCell"
        static let statusScreen = "StatusTableViewCell"
        static let feedEntry = "FeedEntryInfoTableViewCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        feedSourcesController = FeedSourcesSectionController(table: table)
        entriesController = EntriesSectionController(table: table)

        table.dataSource = self
        feedSourcesSectionDataSource = feedSourcesController
        entriesSectionDataSource = entriesController

        table.delegate = self

        table.register(
            UINib(nibName: CellIdentifier.feedsList, bundle: nil),
            forCellReuseIdentifier: CellIdentifier.feedsList
        )
        table.register(
            UINib(nibName: CellIdentifier.trashIcon, bundle: nil),
            forCellReuseIdentifier: CellIdentifier.trashIcon
        )
        table.register(
            UINib(nibName: CellIdentifier.statusScreen, bundle: nil),
            forCellReuseIdentifier: CellIdentifier.statusScreen
        )
        table.register(
            UINib(nibName: CellIdentifier.feedEntry, bundle: nil),
            forCellReuseIdentifier: CellIdentifier.feedEntry
        )

        feedSourcesController.setSelectionDelegate(entriesController)

        table.refreshControl = {
            let control = UIRefreshControl()
            let action = UIAction { action in
                guard let control = action.sender as? UIRefreshControl else {
                    fatalError("Sender is not UIRefreshControl.")
                }
                print("is refreshing")
                control.endRefreshing()
            }
            control.addAction(action, for: .valueChanged)
            return control
        }()
    }

}

extension FeedViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        TableSection.allCases.count
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let typedSection = TableSection(rawValue: section) else {
            fatalError("Section \(section) is invalid.")
        }
        guard let feedSourcesSectionDataSource, let entriesSectionDataSource else {
            fatalError("Data sources are not set.")
        }

        switch typedSection {
        case .feedSources, .trashIcon:
            return feedSourcesSectionDataSource.tableView(tableView, numberOfRowsInSection: section)
        case .status, .entries:
            return entriesSectionDataSource.tableView(tableView, numberOfRowsInSection: section)
        }
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let typedSection = TableSection(rawValue: indexPath.section) else {
            fatalError("Section \(indexPath.section) is invalid.")
        }
        guard let feedSourcesSectionDataSource, let entriesSectionDataSource else {
            fatalError("Data sources are not set.")
        }

        switch typedSection {
        case .feedSources, .trashIcon:
            return feedSourcesSectionDataSource.tableView(tableView, cellForRowAt: indexPath)
        case .status, .entries:
            return entriesSectionDataSource.tableView(tableView, cellForRowAt: indexPath)
        }

    }

}

extension FeedViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let typedSection = TableSection(rawValue: indexPath.section) else {
            fatalError("Section \(indexPath.section) is invalid.")
        }
        return viewModel.tableView(
            tableView,
            contentHeightForSection: typedSection,
            isTrashIconActive: feedSourcesController.viewModel.isDeleteActive
        )
    }

}
