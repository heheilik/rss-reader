//
//  ViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 17.06.23.
//

import UIKit

class ViewController: UIViewController {
    
    let feedService = FeedService()
    
    @IBOutlet weak var feedTitle: UILabel!
    @IBOutlet weak var table: UITableView!
    
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        table.dataSource = feedService
        table.register(UINib(nibName: "RssInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "RssInfoTableViewCell")
    }
    
    
    // MARK: - IBActions
    
    @IBAction func downloadFeedTouchUpInside() {
        feedService.prepareFeed(withIndex: feedService.activeFeedIndex) { feed in
            DispatchQueue.main.async { [self] in
                feedTitle.text = feedService.feed[feedService.activeFeedIndex]?.title.trimmingCharacters(in: .whitespacesAndNewlines) ?? "[feed-title]"
                table.reloadData()
            }
        }
    }

}
