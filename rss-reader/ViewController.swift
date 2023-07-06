//
//  ViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 17.06.23.
//

import UIKit

class ViewController: UIViewController {
    
    let rssFeedUrl = URL(string: "https://www.swift.org/atom.xml")!
    
    let parserDelegate = ParserDelegate()
    
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
        let downloadTask = URLSession.shared.dataTask(with: rssFeedUrl) { data, response, error in
            guard error == nil else {
                print(error ?? "Unknown error.")
                return
            }
            self.parserDelegate.data = data
            DispatchQueue.main.async {
                self.table.reloadData()
                self.feedTitle.text = self.parserDelegate.feed.title
            }
        }
        downloadTask.resume()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parserDelegate.feed.entry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "RssInfoTableViewCell", for: indexPath) as! RssInfoTableViewCell
        
        cell.updateContentsWith(
            title: parserDelegate.feed.entry[indexPath.row].title,
            author: parserDelegate.feed.entry[indexPath.row].author,
            updated: parserDelegate.feed.entry[indexPath.row].updated,
            id: parserDelegate.feed.entry[indexPath.row].id
        )
        return cell
    }
    
    
}
