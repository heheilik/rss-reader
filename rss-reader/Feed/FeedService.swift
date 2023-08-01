//
//  FeedService.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 24.07.23.
//

import UIKit

final class FeedService: NSObject {
    
    override init() {
        super.init()
        if feedUrls.count == 0 {
            feedUrls.append("https://www.swift.org/atom.xml")
        }
        feed = .init(repeating: nil, count: feedUrls.count)
    }
    
    var activeFeedIndex = 0  // wrong
    private(set) var feed: [Feed?] = []  // TODO: make list instead of array
    
    var feedUrls: [String] {  // TODO: (probably) write as NSURL
        get {
            UserDefaults.standard.array(forKey: "urls") as? [String] ?? []
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "urls")
        }
    }
    
    func prepareFeed(withIndex index: Int, completion: @escaping (Feed?) -> Void) {
        guard let url = URL(string: feedUrls[index]) else {
            print("URL is not available.")
            return
        }
        
        let downloadTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error ?? "Unknown error.")
                return
            }
            guard let data else {
                print("No data downloaded.")
                return
            }
            
            let parser = Parser()
            parser.parse(data) { feed in
                self.feed[self.activeFeedIndex] = feed
                completion(feed)
            }
        }
        downloadTask.resume()
    }
    
}

extension FeedService: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed[activeFeedIndex]?.entry.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RssInfoTableViewCell", for: indexPath) as? RssInfoTableViewCell else {
            fatalError("Failed to dequeue (ViewController.entriesTable).")
        }
        
        if let entry = feed[activeFeedIndex]?.entry[indexPath.row] {
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

extension FeedService: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedUrls.count + 1
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
