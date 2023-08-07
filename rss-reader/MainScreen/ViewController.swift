//
//  ViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 17.06.23.
//

import UIKit

class ViewController: UIViewController {
    
    private let feedService = FeedService()
    
    private var feed: [Feed?] = []
    private var activeFeedIndex: Int?  // TODO: remove active feed index
    
    @IBOutlet weak var feedTitle: UILabel!
    @IBOutlet weak var feedsCollection: UICollectionView!
    @IBOutlet weak var entriesTable: UITableView!
    
    private let addFeedViewController = AddFeedViewController()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        feed = .init(repeating: nil, count: FeedURLDatabase.count)
        #warning("Must be recalculated when new feed added.")
        
        feedsCollection.collectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            return layout
        }()
        feedsCollection.delegate = self
        feedsCollection.dataSource = self
        feedsCollection.dragDelegate = self
        feedsCollection.register(
            UINib(nibName: "AddFeedCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "AddFeedCollectionViewCell"
        )
        feedsCollection.register(
            UINib(nibName: "FeedCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "FeedCollectionViewCell"
        )
        
        entriesTable.dataSource = self
        entriesTable.register(
            UINib(nibName: "RssInfoTableViewCell", bundle: nil),
            forCellReuseIdentifier: "RssInfoTableViewCell"
        )
    }
    
    
    // MARK: - feedsCollections actions
    
    @objc
    func plusButtonTouchUpInside() {
        if let sheet = addFeedViewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        present(addFeedViewController, animated: true)
    }
    
    
    // MARK: - addFeedViewController actions
    
    @objc
    func cancelBarButtonTouchUpInside() {
        addFeedViewController.clearFields()
        addFeedViewController.dismiss(animated: true)
    }
    
    @objc
    func saveBarButtonTouchUpInside() {
        if addFeedViewController.saveFields() {
            addFeedViewController.dismiss(animated: true)
            feedsCollection.reloadData()
        }
    }

}

extension ViewController: UITableViewDataSource {
    
    // MARK: - entriesTable Data Source
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if let activeFeedIndex {
            return feed[activeFeedIndex]?.entry.count ?? 0
        }
        return 0
        
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "RssInfoTableViewCell",
            for: indexPath
        ) as? RssInfoTableViewCell else {
            fatalError("Failed to dequeue (ViewController.entriesTable).")
        }
        
        if let activeFeedIndex, let entry = feed[activeFeedIndex]?.entry[indexPath.row] {
            cell.updateContentsWith(entry)
        } else {
            let emptyEntry = Entry(
                title: "No data available.",
                author: "-",
                updated: "-",
                id: "-",
                content: ""
            )
            cell.updateContentsWith(emptyEntry)
        }
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    // MARK: - feedsCollection Data Source
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 1 + FeedURLDatabase.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AddFeedCollectionViewCell",
                for: indexPath
            ) as? AddFeedCollectionViewCell else {
                fatalError("Failed to dequeue (ViewController.feedCollection).")
            }
            
            cell.plusButton.addTarget(
                self,
                action: #selector(plusButtonTouchUpInside),
                for: .touchUpInside
            )
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "FeedCollectionViewCell",
            for: indexPath
        ) as? FeedCollectionViewCell else {
            fatalError("Failed to dequeue (ViewController.feedCollection).")
        }
        
        cell.updateContentsWith(FeedURLDatabase.nameAt(indexPath.row - 1) ?? "[error]")
        cell.isSelected = false
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - feedsCollection Delegate
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let inset = self.collectionView(
            collectionView,
            layout: collectionViewLayout,
            insetForSectionAt: indexPath.section
        )
        let spacing = self.collectionView(
            collectionView,
            layout: collectionViewLayout,
            minimumInteritemSpacingForSectionAt: indexPath.section
        )
        let contentHeight = collectionView.bounds.size.height
        let contentWidth = collectionView.bounds.size.width
        
        let plusSize = CGSize(width: contentHeight, height: contentHeight)
        
        if indexPath.row == 0 {
            return plusSize
        }
        
        return CGSize(
            width: (contentWidth - plusSize.width - inset.left - 3 * spacing) / 2.5,
            height: contentHeight
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print("\(indexPath)")
        return indexPath.row != 0 && !(collectionView.cellForItem(at: indexPath)?.isSelected ?? true)
    }
    
    #warning("Rewrite")
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        activeFeedIndex = indexPath.row - 1
        guard let activeFeedIndex else {
            return
        }
        feedService.prepareFeed(withURL: FeedURLDatabase.urlAt(indexPath.row - 1)!) { feed in
            guard let activeFeedIndex = self.activeFeedIndex else {
                return
            }
            self.feed[activeFeedIndex] = feed
            DispatchQueue.main.async { [self] in
                feedTitle.text = self.feed[activeFeedIndex]?.title.trimmingCharacters(in: .whitespacesAndNewlines) ?? "[feed-title]"
                entriesTable.reloadData()
            }
        }
    }
    
}

extension ViewController: UICollectionViewDragDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        if indexPath.row == 0 {
            return []
        }
        
        let objProvider = NSItemProvider(item: NSNumber(value: indexPath.row - 1), typeIdentifier: "feedIndex")
        let item = UIDragItem(itemProvider: objProvider)
        return [item]
    }
    
    
    
    
}
