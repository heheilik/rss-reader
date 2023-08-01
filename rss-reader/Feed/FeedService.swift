//
//  FeedService.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 24.07.23.
//

import UIKit

final class FeedService {
    
    func prepareFeed(with url: URL, completion: @escaping (Feed?) -> Void) {
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
                completion(feed)
            }
        }
        downloadTask.resume()
    }
    
}
