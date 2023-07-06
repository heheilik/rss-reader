//
//  ParserDelegate.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 6.07.23.
//

import Foundation

class ParserDelegate: NSObject, XMLParserDelegate {
    
    var parser: XMLParser?
    
    var data: Data? {
        didSet {
            guard let data else {
                print("No data found.")
                return
            }
            
            parser = XMLParser(data: data)
            guard let parser else {
                return
            }
            
            parser.delegate = self
            parser.parse()
        }
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Parsing started.")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print("Parsing ended.")
    }
    
}

struct Feed: Codable {
    var xmlns: String
    var title: String
    var updated: String
    var id: String
    var entry: [Entry]
}

struct Entry: Codable {
    var title: String
    var author: String
    var updated: String
    var id: String
    var content: String
}
