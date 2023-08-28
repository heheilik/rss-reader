//
//  AddFeedSourceViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 28.08.23.
//

import UIKit

class AddFeedSourceViewModel {

    enum DataFieldError: Error {
        case emptyName
        case emptyUrl
        case incorrectUrl
    }

    func createFeedSource(name: String?, urlString: String?) throws -> FeedSource {
        guard let name, name.count != 0 else {
            throw DataFieldError.emptyName
        }
        guard let urlString, urlString.count != 0 else {
            throw DataFieldError.emptyUrl
        }
        guard
            let url = URL(string: urlString),
            let scheme = url.scheme,
            scheme == "http" || scheme == "https",
            url.host() != nil
        else {
            throw DataFieldError.incorrectUrl
        }

        return FeedSource(name: name, url: url)
    }

    func generateAlertController(forErrorType errorType: DataFieldError) -> UIAlertController {
        let alertController: UIAlertController

        switch errorType {
        case .emptyName:
            alertController = UIAlertController(
                title: "Empty Name Field",
                message: "Please fill in the name of feed.",
                preferredStyle: .alert
            )
        case .emptyUrl:
            alertController = UIAlertController(
                title: "Empty URL Field",
                message: "Please fill in the name of feed.",
                preferredStyle: .alert
            )
        case .incorrectUrl:
            alertController = UIAlertController(
                title: "Incorrect URL",
                message: "Check the correctness of entered URL.",
                preferredStyle: .alert
            )
        }
        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        return alertController
    }

}
