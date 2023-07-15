//
//  ParserDelegate.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 6.07.23.
//

import Foundation

class ParserDelegate: NSObject, XMLParserDelegate {
    
    private var parser: XMLParser?
    
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
    
    private var isInsideEntry = false
    private var isInsideContent = false
    private var elementStack: [TrackedElement] = []
    
    enum TrackedElement: String {
        case feed
        case entry
        case content
        case title
        case author
        case updated
        case id
    }
    
    
    // MARK: - start/end element
    
    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]
    ) {
        let currentElement = TrackedElement(rawValue: elementName)
        guard let currentElement else {
            return
        }
        
        elementStack.append(currentElement)
        
        switch currentElement {
        case .feed:
            feed = Feed()
    
        case .entry:
            feed.entry.append(Entry())
            isInsideEntry = true
            
        case .content:
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
        let currentElement = TrackedElement(rawValue: elementName)
        guard let currentElement else {
            return
        }
        
        if elementStack.last == currentElement {
            elementStack.removeLast()
        }
        
        switch currentElement {
        case .entry:
            isInsideEntry = false
            
        case .content:
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
            case .title:
                feed.title.append(string)
            case .updated:
                feed.updated.append(string)
            case .id:
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
            case .title:
                feed.entry[lastEntryIndex].title.append(string)
            case .author:
                feed.entry[lastEntryIndex].author.append(string)
            case .updated:
                feed.entry[lastEntryIndex].updated.append(string)
            case .id:
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
        
        for index in feed.entry.indices {
            feed.entry[index].title = feed.entry[index].title.trimmingCharacters(in: .whitespacesAndNewlines)
            feed.entry[index].author = feed.entry[index].author.trimmingCharacters(in: .whitespacesAndNewlines)
            feed.entry[index].updated = feed.entry[index].updated.trimmingCharacters(in: .whitespacesAndNewlines)
            feed.entry[index].id = feed.entry[index].id.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        
    }
}

struct Feed {
    var title: String = ""
    var updated: String = ""
    var id: String = ""
    var entry: [Entry] = []
}

struct Entry {
    var title: String = ""
    var author: String = ""
    var updated: String = ""
    var id: String = ""
    var content: String = ""
}
