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

}
