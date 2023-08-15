//
//  FeedViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 17.06.23.
//

import UIKit

class FeedViewController: UIViewController {
    
    private var viewModel = FeedViewModel()
    
    @IBOutlet weak var entriesTable: UITableView!
    
    enum SectionIndex: Int {
        case feedsList = 0
        case trashIcon
        case feedEntries
    }

    enum CellIdentifier {
        static let feedsList = "FeedsListTableViewCell"
        static let trashIcon = "TrashIconTableViewCell"
        static let feedEntry = "RssInfoTableViewCell"
    }
    
    
    
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
        2
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let section = SectionIndex.init(rawValue: section) else {
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
        guard let section = SectionIndex.init(rawValue: indexPath.section) else {
            fatalError("Section is invalid.")
        }
        
        switch section {
        case .feedsList:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.feedsList,
                for: indexPath
            ) as? FeedsListTableViewCell else {
                fatalError("Failed to dequeue \(CellIdentifier.feedsList)")
            }
            return cell
            
        case .trashIcon:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.trashIcon,
                for: indexPath
            ) as? TrashIconTableViewCell else {
                fatalError("Failed to dequeue \(CellIdentifier.trashIcon)")
            }
            return cell
            
        case .feedEntries:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.feedEntry,
                for: indexPath
            ) as? FeedEntryInfoTableViewCell else {
                fatalError("Failed to dequeue \(CellIdentifier.feedEntry)")
            }
            
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
    
}

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SectionIndex.init(rawValue: indexPath.section) else {
            fatalError("Section is invalid.")
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
