//
//  FeedURLDatabase.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 1.08.23.
//

import Foundation

#warning("Create cache.")
struct FeedURLDatabase {
    
    typealias StringWithUrl = (name: String, url: URL)
    
    private enum UserDefaultsAccessKey {
        static let names = "names"
        static let urls = "urls"
    }
    
    static var array: [StringWithUrl] {
        get {
            guard
                let nameArray = UserDefaults.standard.value(forKey: UserDefaultsAccessKey.names) as? [String],
                let urlArray = UserDefaults.standard.value(forKey: UserDefaultsAccessKey.urls) as? [String]
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
                nameArray[index] = newValue[index].name
                urlArray[index] = newValue[index].url.absoluteString
            }
            
            UserDefaults.standard.setValue(nameArray, forKey: UserDefaultsAccessKey.names)
            UserDefaults.standard.setValue(urlArray, forKey: UserDefaultsAccessKey.urls)
        }
    }

}
