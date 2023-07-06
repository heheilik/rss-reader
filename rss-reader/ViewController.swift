//
//  ViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 17.06.23.
//

import UIKit

//struct Feed: Codable {
//    @Attribute var xmlns: String
//    @Element var title: String
//    @Element var updated: String
//    @Element var id: String
//    var entry: [Entry]
//}
//
//struct Entry: Codable {
//    @Element var title: String
//    @Element var author: String
//    @Element var updated: String
//    @Element var id: String
//    @Element var content: String
//}

class ViewController: UIViewController {
    
    let rssFeedUrl = "https://www.swift.org/atom.xml"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    @IBAction func downloadFeedTouchUpInside() {
        let downloadTask = URLSession.shared.dataTask(with: URL(string: rssFeedUrl)!) { data, response, error in
            guard error == nil else {
                print(error ?? "Unknown error.")
                return
            }
            
            guard let data else {
                print("No data downloaded.")
                return
            }
        }
        downloadTask.resume()
    }

}
