//
//  ViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 17.06.23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    @IBAction func downloadFeedTouchUpInside() {
        let downloadTask = URLSession.shared.dataTask(with: URL(string: "https://www.swift.org/atom.xml")!) { data, response, error in
            guard error == nil else {
                print(error ?? "Unknown error.")
                return
            }
            print(data ?? "Data can't be cast to string.")
        }
        downloadTask.resume()
    }

}
