//
//  AddFeedSourceViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 6.08.23.
//

import UIKit

class AddFeedSourceViewController: UIViewController {

    private let viewModel = AddFeedSourceViewModel()
    typealias DataFieldError = AddFeedSourceViewModel.DataFieldError

    var saveDataCallback: ((FeedSource) -> Void)?

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var urlField: UITextField!

    @IBAction func cancelButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func saveButtonTouchUpInside(_ sender: Any) {
        let feedSource: FeedSource
        do {
            feedSource = try viewModel.createFeedSource(
                name: nameField.text,
                urlString: urlField.text
            )
        } catch let error as DataFieldError {
            let alert = viewModel.generateAlertController(forErrorType: error)
            present(alert, animated: true)
            return
        } catch {
            print("Unexpected error (\(error)).")
            return
        }

        if let saveDataCallback {
            saveDataCallback(feedSource)
        }
        dismiss(animated: true)
    }

}
