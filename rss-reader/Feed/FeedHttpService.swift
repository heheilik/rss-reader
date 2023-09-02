//
//  FeedHttpService.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 24.07.23.
//

import UIKit

final class FeedHttpService {

    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func prepareFeed(
        withURL url: URL,
        completion: @escaping (ParsedFeed?) -> Void
    ) -> URLSessionDataTask {
        let downloadTask = urlSession.dataTask(with: url) { data, _, error in
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
        return downloadTask
    }

}
