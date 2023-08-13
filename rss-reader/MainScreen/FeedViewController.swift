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
            fatalError("Section is invalid.")
        }
        
        switch section {
        case .feedsList:
            return 1
        case .trashIcon:
            return 0
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
            fatalError("TrashIcon isn't implemented.")
            
        case .feedEntries:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifier.feedEntry,
                for: indexPath
            ) as? RssInfoTableViewCell else {
                fatalError("Failed to dequeue \(CellIdentifier.feedsList)")
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
        if section == .feedsList {
            return 64
        } else {
            return 0
        }
    }
}
