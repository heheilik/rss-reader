//
//  EntriesViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 5.09.23.
//

import UIKit
import CoreData

class EntriesViewController: UIViewController {

    let viewModel: EntriesViewModel

    @IBOutlet private weak var tableView: UITableView!
    let fetchedResultsController: NSFetchedResultsController<Entry>

    weak var scrollViewDelegate: UIScrollViewDelegate?

    init(
        viewModel: EntriesViewModel = EntriesViewModel()
    ) {
        self.viewModel = viewModel
        fetchedResultsController = viewModel.feedDataProvider.fetchedResultsController

        super.init(nibName: String(describing: Self.self), bundle: nil)

        viewModel.dataChangedCallback = { [weak self] in
            if let self {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            nib: UINib(nibName: "FeedSourcesPlaceholderTableViewCell", bundle: nil),
            for: FeedSourcesPlaceholderTableViewCell.self
        )
        tableView.register(
            nib: UINib(nibName: "FeedEntryInfoTableViewCell", bundle: nil),
            for: FeedEntryInfoTableViewCell.self
        )
        tableView.register(
            nib: UINib(nibName: "StatusTableViewCell", bundle: nil),
            for: StatusTableViewCell.self
        )
    }

}

extension EntriesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sectionCount()
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        let typedSection = viewModel.section(forIndex: section)
        switch typedSection {
        case .feedSourcesPlaceholder:
            return 1
        case .status:
            switch viewModel.state {
            case .start, .loading:
                return 1
            case .showing:
                return 0
            }
        case .entries:
            return fetchedResultsController.fetchedObjects?.count ?? 0
        }
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let typedSection = viewModel.section(forIndexPath: indexPath)
        switch typedSection {
        case .feedSourcesPlaceholder:
            return tableView.dequeue(
                FeedSourcesPlaceholderTableViewCell.self,
                for: indexPath
            ) { _ in }

        case .status:
            return tableView.dequeue(
                StatusTableViewCell.self,
                for: indexPath
            ) { cell in
                switch viewModel.state {
                case .start:
                    cell.setStatus(.start)
                case .loading:
                    cell.setStatus(.loading)
                case .showing:
                    break
                }
            }

        case .entries:
            return tableView.dequeue(FeedEntryInfoTableViewCell.self, for: indexPath) { cell in
                let newIndexPath = IndexPath(row: indexPath.row, section: 0)
                cell.updateContentsWith(fetchedResultsController.object(at: newIndexPath))
            }
        }
    }

}

extension EntriesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let typedSection = viewModel.section(forIndexPath: indexPath)
        switch typedSection {
        case .feedSourcesPlaceholder:
            return 64
        case .status:
             return tableView.bounds.height - 64
        case .entries:
            return UITableView.automaticDimension
        }
    }

    // MARK: - Scrolling

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

}

extension EntriesViewController: FeedSourcesURLListDelegate {

    func onUrlSetUpdated(set: Set<URL>) {
        viewModel.updateUrlSet(with: set)
        print(viewModel.state)
    }

}
