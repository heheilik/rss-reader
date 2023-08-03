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
    
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        feed = .init(repeating: nil, count: FeedURLDatabase.urlArray.count)
        activeFeedIndex = 0
        
        feedsCollection.dataSource = self
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
    
    
    // MARK: - IBActions
    
    @IBAction func downloadFeedTouchUpInside() {
        guard let activeFeedIndex else {
            return
        }
        feedService.prepareFeed(withURL: FeedURLDatabase.urlArray[activeFeedIndex]) { feed in
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

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let activeFeedIndex else {
            print("No feed chosen.")
            return 0
        }
        return feed[activeFeedIndex]?.entry.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RssInfoTableViewCell", for: indexPath) as? RssInfoTableViewCell else {
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

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FeedURLDatabase.urlArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddFeedCollectionViewCell", for: indexPath) as? AddFeedCollectionViewCell else {
                fatalError("Failed to dequeue (ViewController.feedCollection).")
            }
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionViewCell", for: indexPath) as? FeedCollectionViewCell else {
            fatalError("Failed to dequeue (ViewController.feedCollection).")
        }
        cell.updateContentsWith("some text")
        return cell
                
    }
    
}
