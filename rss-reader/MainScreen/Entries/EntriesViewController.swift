//
//  EntriesViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 5.09.23.
//

import UIKit
import CoreData

class EntriesViewController: UIViewController {

    let viewModel = EntriesViewModel()

    @IBOutlet private weak var tableView: UITableView!

    weak var scrollViewDelegate: UIScrollViewDelegate?

    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            nib: UINib(nibName: "FeedSourcesPlaceholderTableViewCell", bundle: nil),
            for: FeedSourcesPlaceholderTableViewCell.self
        )
        tableView.register(
            nib: UINib(nibName: "FeedEntryTableViewCell", bundle: nil),
            for: FeedEntryInfoTableViewCell.self
        )
        tableView.register(
            nib: UINib(nibName: "StatusTableViewCell", bundle: nil),
            for: StatusTableViewCell.self
        )

        viewModel.setDelegate(delegate: self)
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
            return 1
        case .entries:
            return 0
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
                var newIndexPath = indexPath
                newIndexPath.section = 0
                viewModel.feedDataProvider.fetchedResultsController.object(at: indexPath)
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
            // FIXME: temporarily increased height for testing
            // return tableView.bounds.height - 64
            return tableView.bounds.height * 2
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

extension EntriesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>
    ) {
        tableView.reloadData()
    }

}

extension EntriesViewController: FeedSourcesURLListDelegate {

    func onUrlSetUpdated(set: Set<URL>) {
        viewModel.updateUrlSet(with: set)
    }

}
