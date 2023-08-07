//
//  AddFeedViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 6.08.23.
//

import UIKit

class AddFeedViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var urlField: UITextField!
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        cancelBarButton.action = #selector(ViewController.cancelBarButtonTouchUpInside)
        saveBarButton.action = #selector(ViewController.saveBarButtonTouchUpInside)
    }
    
    func clearFields() {
        nameField.text = ""
        urlField.text = ""
    }
    
    func saveFields() -> Bool {
        guard
            let name = nameField.text,
            let url = URL(string: urlField.text ?? "")
        else {
            return false
        }
        
        FeedURLDatabase.append(name: name, url: url)
        clearFields()
        return true
    }

}
