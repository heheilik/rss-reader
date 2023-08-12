//
//  FeedURLDatabase.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 1.08.23.
//

import Foundation

struct FeedURLDatabase {
    
    typealias StringWithUrl = (name: String, url: URL)
    private static let userDefaultsAccessKeyName = "names"
    private static let userDefaultsAccessKeyUrl = "urls"
    
    static var array: [StringWithUrl] {
        get {
            guard
                let nameArray = UserDefaults.standard.value(forKey: userDefaultsAccessKeyName) as? [String],
                let urlArray = UserDefaults.standard.value(forKey: userDefaultsAccessKeyUrl) as? [String]
            else {
                return []
            }
            
            var result = [StringWithUrl]()
            for index in nameArray.indices {
                result.append((nameArray[index], URL(string: urlArray[index])!))
            }
            return result
        }
        set {
            var nameArray: [String] = .init(repeating: "", count: newValue.count)
            var urlArray: [String] = .init(repeating: "", count: newValue.count)
            for index in newValue.indices {
                nameArray[index] = newValue[index].0
                urlArray[index] = newValue[index].1.absoluteString
            }
            
            UserDefaults.standard.setValue(nameArray, forKey: userDefaultsAccessKeyName)
            UserDefaults.standard.setValue(urlArray, forKey: userDefaultsAccessKeyUrl)
        }
    }

}
