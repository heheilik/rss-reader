//
//  FeedURLDatabase.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 1.08.23.
//

import Foundation

// TODO: save it as dictionary [url: name], both strings
struct FeedURLDatabase {
    
    private static var nameArray: [String] {
        get {
            UserDefaults.standard.array(forKey: "names") as? [String] ?? []
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "names")
        }
    }
    
    private static var urlArray: [String] {
        get {
            UserDefaults.standard.array(forKey: "urls") as? [String] ?? []
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "urls")
        }
    }
    
    
    static func nameAt(_ index: Int) -> String? {
        guard nameArray.count > index else {
            return nil
        }
        return nameArray[index]
    }
    
    static func urlAt(_ index: Int) -> URL? {
        guard urlArray.count > index else {
            return nil
        }
        return URL(string: urlArray[index]) ?? nil
    }
    
    static func append(name: String, url: URL) {
        nameArray.append(name)
        urlArray.append(url.absoluteString)
    }
    
    static func remove(at index: Int) {
        nameArray.remove(at: index)
        urlArray.remove(at: index)
    }
    
    static func swapAt(_ firstIndex: Int, _ secondIndex: Int) {
        nameArray.swapAt(firstIndex, secondIndex)
        urlArray.swapAt(firstIndex, secondIndex)
    }
    
    static var count: Int {
        return nameArray.count
    }
    
}
