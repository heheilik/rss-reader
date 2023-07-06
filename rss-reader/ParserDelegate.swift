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
            isFeedCorrect = parser.parse()
        }
    }
    
    private(set) var feed = Feed()
    private(set) var isFeedCorrect = false
    
    var isInsideEntry = false
    var isInsideContent = false
    var elementStack: [String] = []
    let trackedElements: Set = ["feed", "entry", "content", "title", "author", "updated", "id"]
    
    
    // MARK: - start/end element
    
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        if trackedElements.contains(elementName) {
            elementStack.append(elementName)
        }
        
        
        switch elementName {
        case "feed":
            feed = Feed()
    
        case "entry":
            feed.entry.append(Entry())
            isInsideEntry = true
            
        case "content":
            isInsideContent = true
            
        default:
            break
        }
    }
    
    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        if elementStack.last == elementName {
            elementStack.removeLast()
        } else {
            // print("Parsing error: found end of element that didn't start.")
            // TODO: create XML parsing error
        }
        
        switch elementName {
        case "entry":
            isInsideEntry = false
            
        case "content":
            isInsideContent = false
            
        default:
            break
        }
    }
    
    
    // MARK: - process elements in tag
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let currentElement = elementStack.last else {
            return
        }
        
        if !isInsideEntry {
            switch currentElement {
            case "title":
                feed.title.append(string)
            case "updated":
                feed.updated.append(string)
            case "id":
                feed.id.append(string)
            default:
                break
            }
        } else {
            let lastEntryIndex = feed.entry.count - 1
            guard lastEntryIndex >= 0 else {
                return
            }
            
            if isInsideContent {
                feed.entry[lastEntryIndex].content.append(string)
                return
            }
            
            switch currentElement {
            case "title":
                feed.entry[lastEntryIndex].title.append(string)
            case "author":
                feed.entry[lastEntryIndex].author.append(string)
            case "updated":
                feed.entry[lastEntryIndex].updated.append(string)
            case "id":
                feed.entry[lastEntryIndex].id.append(string)
            default:
                break
            }
        }
    }
    
    
    // MARK: - start/end document
    
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Parsing started.")
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        print("Parsing ended.")
        
        feed.title = feed.title.trimmingCharacters(in: .whitespacesAndNewlines)
        feed.updated = feed.updated.trimmingCharacters(in: .whitespacesAndNewlines)
        feed.id = feed.id.trimmingCharacters(in: .whitespacesAndNewlines)
        
        for i in feed.entry.indices {
            feed.entry[i].title = feed.entry[i].title.trimmingCharacters(in: .whitespacesAndNewlines)
            feed.entry[i].author = feed.entry[i].author.trimmingCharacters(in: .whitespacesAndNewlines)
            feed.entry[i].updated = feed.entry[i].updated.trimmingCharacters(in: .whitespacesAndNewlines)
            feed.entry[i].id = feed.entry[i].id.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}

struct Feed: Codable {
    var title: String = ""
    var updated: String = ""
    var id: String = ""
    var entry: [Entry] = []
}

struct Entry: Codable {
    var title: String = ""
    var author: String = ""
    var updated: String = ""
    var id: String = ""
    var content: String = ""
}
