//
//  Parser.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 27.07.23.
//

import UIKit

final class Parser: NSObject {
    
    private(set) var feed: Feed?
    
    func parse(_ data: Data, completion: @escaping (Feed?) -> Void) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        DispatchQueue.global().async {
            self.clearTempData()
            parser.parse()
            completion(self.feed)
        }
    }
    
    enum TrackedElement: String {
        case entry
        case content
        case title
        case author
        case updated
        case id
    }
    
    private var elementStack: [TrackedElement] = []
    
    private var feedTitle = ""
    private var feedUpdated = ""
    private var feedId = ""
    
    private var entries: [Entry] = []
    private var entryTitle = ""
    private var entryAuthor = ""
    private var entryUpdated = ""
    private var entryId = ""
    private var entryContent = ""

    func clearTempData() {
        elementStack = []
        
        feedTitle = ""
        feedUpdated = ""
        feedId = ""
        
        entries = []
        entryTitle = ""
        entryAuthor = ""
        entryUpdated = ""
        entryId = ""
        entryContent = ""
    }
    
    
}

extension Parser: XMLParserDelegate {
    
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
        
        if currentElement == .entry {
            entryTitle = ""
            entryAuthor = ""
            entryUpdated = ""
            entryId = ""
            entryContent = ""
        }
        
        elementStack.append(currentElement)
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
        
        if currentElement == .entry {
            entries.append(Entry(
                title: entryTitle.trimmingCharacters(in: .whitespacesAndNewlines),
                author: entryAuthor.trimmingCharacters(in: .whitespacesAndNewlines),
                updated: entryUpdated.trimmingCharacters(in: .whitespacesAndNewlines),
                id: entryId.trimmingCharacters(in: .whitespacesAndNewlines),
                content: entryContent.trimmingCharacters(in: .whitespacesAndNewlines)
            ))
        }
        
        if elementStack.last == currentElement {
            elementStack.removeLast()
        }
    }
    
    
    // MARK: - process elements in tag
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let currentElement = elementStack.last else {
            return
        }
        
        if elementStack[0] != .entry {
            switch currentElement {
            case .title:
                feedTitle.append(string)
            case .updated:
                feedUpdated.append(string)
            case .id:
                feedId.append(string)
            default:
                break
            }
            return
        }
        
        switch currentElement {
        case .title:
            entryTitle.append(string)
        case .author:
            entryAuthor.append(string)
        case .updated:
            entryUpdated.append(string)
        case .id:
            entryId.append(string)
        case .content:
            entryContent.append(string)
        default:
            break
        }
    }
    
    
    // MARK: - start/end document
    
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Parsing started.")
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        print("Parsing ended.")
        
        feed = Feed(
            title: feedTitle.trimmingCharacters(in: .whitespacesAndNewlines),
            updated: feedUpdated.trimmingCharacters(in: .whitespacesAndNewlines),
            id: feedId.trimmingCharacters(in: .whitespacesAndNewlines),
            entry: entries
        )
    }
    
}