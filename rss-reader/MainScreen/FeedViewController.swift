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

enum CellIdentifier {
    static let feedsList = "FeedSourcesListTableViewCell"
    static let trashIcon = "TrashIconTableViewCell"
    static let statusScreen = "StatusTableViewCell"
    static let feedEntry = "FeedEntryInfoTableViewCell"
}

class FeedViewController: UIViewController {

    private var feedSourcesController: FeedSourcesSectionController!
    private var entriesController: EntriesSectionController!

    private weak var feedSourcesSectionDataSource: UITableViewDataSource?
    private weak var entriesSectionDataSource: UITableViewDataSource?

    @IBOutlet weak var table: UITableView!

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

    enum TableSizeConstant {
        static let feedsListHeight: CGFloat = 64
        static let trashIconHeight: CGFloat = 64
        static let bottomInset: CGFloat = 8
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let typedSection = TableSection(rawValue: indexPath.section) else {
            fatalError("Section \(indexPath.section) is invalid.")
        }

        switch typedSection {
        case .feedSources:
            return TableSizeConstant.feedsListHeight + TableSizeConstant.bottomInset
        case .trashIcon:
            return TableSizeConstant.trashIconHeight + TableSizeConstant.bottomInset
        case .status:
            return tableContentHeight(totalHeight: tableView.bounds.height)
        case .entries:
            return UITableView.automaticDimension
        }
    }

    // TODO: Move to ViewModel.
    func tableContentHeight(totalHeight: CGFloat) -> CGFloat {
        var result = totalHeight
        result -= feedsListTotalHeight()
        if feedSourcesController.isDeleteActive {
            result -= trashIconTotalHeight()
        }
        return result
    }

    func feedsListTotalHeight() -> CGFloat {
        TableSizeConstant.feedsListHeight + TableSizeConstant.bottomInset
    }
    func trashIconTotalHeight() -> CGFloat {
        TableSizeConstant.trashIconHeight + TableSizeConstant.bottomInset
    }

}
