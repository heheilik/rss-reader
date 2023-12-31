//
//  ViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 17.06.23.
//

import UIKit

class ViewController: UIViewController {
    
    let rssFeedUrl = URL(string: "https://www.swift.org/atom.xml")!
    
    var currentFeedName = "Swift"
    var feed = ["Swift": Feed()]
    let feedService = FeedService()
    
    @IBOutlet weak var feedTitle: UILabel!
    @IBOutlet weak var table: UITableView!
    
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: "RssInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "RssInfoTableViewCell")
    }
    
    
    // MARK: - IBActions
    
    @IBAction func downloadFeedTouchUpInside() {
        feedService.prepareFeed(with: rssFeedUrl) { feed in
            self.feed[self.currentFeedName] = feed
            DispatchQueue.main.async {
                self.feedTitle.text = self.feed[self.currentFeedName]?.title.trimmingCharacters(in: .whitespacesAndNewlines) ?? "[feed-title]"
                self.table.reloadData()
            }
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed[currentFeedName]?.entry.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: "RssInfoTableViewCell", for: indexPath) as? RssInfoTableViewCell else {
            fatalError("Failed to dequeue.")
        }
        
        if let entry = feed[currentFeedName]?.entry[indexPath.row] {
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
