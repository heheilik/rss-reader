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
    
    
    // MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    
    // MARK: - IBActions
    
    @IBAction func downloadFeedTouchUpInside() {
        let downloadTask = URLSession.shared.dataTask(with: rssFeedUrl) { data, response, error in
            guard error == nil else {
                print(error ?? "Unknown error.")
                return
            }
            self.parserDelegate.data = data
        }
        downloadTask.resume()
    }

}
