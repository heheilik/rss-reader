//
//  FeedURLDatabase.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 1.08.23.
//

import Foundation

// TODO: save it as dictionary [url: name], both strings
struct FeedURLDatabase {
    
    private(set) static var nameArray: [String] {
        get {
            UserDefaults.standard.array(forKey: "names") as? [String] ?? []
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "names")
        }
    }
    
    private(set) static var urlArray: [String] {
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
    
    static func urlAt(_ index: Int) -> String? {
        guard urlArray.count > index else {
            return nil
        }
        return urlArray[index]
    }
    
    static func append(_ element: (String, String)) {
        nameArray.append(element.0)
        urlArray.append(element.1)
    }
    
    static func insert(_ element: (String, String), at index: Int) {
        nameArray.insert(element.0, at: index)
        urlArray.insert(element.1, at: index)
    }
    
    static func remove(at index: Int) -> (String, String) {
        let name = nameArray.remove(at: index)
        let url = urlArray.remove(at: index)
        return (name, url)
    }
    
    static func swapAt(_ firstIndex: Int, _ secondIndex: Int) {
        nameArray.swapAt(firstIndex, secondIndex)
        urlArray.swapAt(firstIndex, secondIndex)
    }
    
    static var count: Int {
        return nameArray.count
    }
    
}
