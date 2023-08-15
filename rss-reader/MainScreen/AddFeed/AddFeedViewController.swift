//
//  AddFeedViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 6.08.23.
//

import UIKit

class AddFeedViewController: UIViewController {
    
    var saveDataCallback: ((String, URL) -> Void)?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var urlField: UITextField!
    
    @IBAction func cancelButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonTouchUpInside(_ sender: Any) {
        let data: (name: String, url: URL)
        do {
            data = try retrieveDataFromFields()
        } catch let error as DataFieldError {
            generateAlert(forErrorType: error)
            return
        } catch {
            print("Unexpected error (\(error)).")
            return
        }
        
        if let callback = saveDataCallback {
            callback(data.name, data.url)
        }
        dismiss(animated: true)
    }
    
                    
    private enum DataFieldError: Error {
        case emptyName
        case emptyUrl
        case incorrectUrl
    }
    
    private func retrieveDataFromFields() throws -> (name: String, url: URL) {
        guard let name = nameField.text, name.count != 0 else {
            throw DataFieldError.emptyName
        }
        guard let urlString = urlField.text, urlString.count != 0 else {
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
        
        return (name, url)
    }
    
    private func generateAlert(forErrorType errorType: DataFieldError) {
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
        
        present(alertController, animated: true)
    }

}
