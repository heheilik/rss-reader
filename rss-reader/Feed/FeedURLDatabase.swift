//
//  FeedURLDatabase.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 1.08.23.
//

import Foundation

struct FeedURLDatabase {
    
    static var urlArray: [String] {  // TODO: change to NSURL array
        get {
            UserDefaults.standard.array(forKey: "urls") as? [String] ?? []
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "urls")
        }
    }
    
}
