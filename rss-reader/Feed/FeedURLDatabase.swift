//
//  FeedURLDatabase.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 1.08.23.
//

import Foundation

struct FeedURLDatabase {
    
    private static var cache: [FeedSource]? = nil
    
    private enum UserDefaultsAccessKey {
        static let names = "names"
        static let urls = "urls"
    }
    
    static var array: [FeedSource] {
        get {
            if let cache {
                return cache
            }
            
            guard
                let nameArray = UserDefaults.standard.value(forKey: UserDefaultsAccessKey.names) as? [String],
                let urlArray = UserDefaults.standard.value(forKey: UserDefaultsAccessKey.urls) as? [String]
            else {
                return []
            }
            
            var result = [FeedSource]()
            for index in nameArray.indices {
                result.append(FeedSource(
                    name: nameArray[index],
                    url: URL(string: urlArray[index])!
                ))
            }
            
            cache = result
            return result
        }
        set {
            cache = newValue
            
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
