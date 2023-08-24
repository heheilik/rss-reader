//
//  Parser.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 27.07.23.
//

import UIKit

final class Parser: NSObject {

    override init() {
        super.init()
        for key in entryDataRequiredKeys {
            entryData[key] = ""
        }
        for key in feedDataRequiredKeys {
            feedData[key] = ""
        }
    }

    func parse(_ data: Data, completion: @escaping (RawFeed?) -> Void) {
        DispatchQueue.global().async {
            let parser = XMLParser(data: data)
            parser.delegate = self
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

    private var feedData: [TrackedElement: String] = [:]
    private let feedDataRequiredKeys: Set<TrackedElement> = [.title, .updated, .id]
    private var entryData: [TrackedElement: String] = [:]
    private let entryDataRequiredKeys: Set<TrackedElement> = [.title, .author, .updated, .id, .content]

    private var entries: [RawEntry] = []
    private var feed: RawFeed?

}

extension Parser: XMLParserDelegate {

    // MARK: - start/end element

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]
    ) {
        let currentElement = TrackedElement(rawValue: elementName)
        guard let currentElement else {
            return
        }

        if currentElement == .entry {
            for key in entryData.keys {
                entryData[key] = ""
            }
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
            guard Set(entryData.keys) == entryDataRequiredKeys else {
                fatalError("Required key was deleted from entryData dictionary.")
            }
            entries.append(RawEntry(
                header: RawEntry.Header(
                    title: entryData[.title] ?? "[error]",
                    author: entryData[.author] ?? "[error]",
                    updated: entryData[.updated] ?? "[error]",
                    id: entryData[.id] ?? "[error]"
                ),
                content: entryData[.content] ?? "[error]"
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
            case .title, .updated, .id:
                feedData[currentElement]?.append(string)
            case .entry, .content, .author:
                break
            }
            return
        }

        switch currentElement {
        case .title, .author, .updated, .id, .content:
            entryData[currentElement]?.append(string)
        case .entry:
            break
        }
    }

    // MARK: - start/end document

    func parserDidEndDocument(_ parser: XMLParser) {
        guard Set(feedData.keys) == feedDataRequiredKeys else {
            fatalError("Required key was deleted from feedData dictionary.")
        }
        feed = RawFeed(
            header: RawFeed.Header(
                title: feedData[.title] ?? "[error]",
                updated: feedData[.updated] ?? "[error]",
                id: feedData[.id] ?? "[error]"
            ),
            entries: entries
        )
    }

}
