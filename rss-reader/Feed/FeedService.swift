//
//  FeedService.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 24.07.23.
//

import UIKit

final class FeedService {
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    let urlSession: URLSession
    
    func prepareFeed(withURL url: String, completion: @escaping (Feed?) -> Void) {
        guard let url = URL(string: url) else {
            print("URL is wrong.")
            return
        }
        
        let downloadTask = urlSession.dataTask(with: url) { data, response, error in
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
