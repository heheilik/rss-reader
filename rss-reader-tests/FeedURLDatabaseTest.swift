//
//  FeedURLDatabaseTest.swift
//  rss-reader-tests
//
//  Created by Heorhi Heilik on 12.08.23.
//

import XCTest

final class FeedURLDatabaseTest: XCTestCase {

    let testArray = [
        FeedSource(name: "Swift Feed", url: URL(string: "https://www.swift.org/atom.xml")!),
        FeedSource(name: "YouTube", url: URL(string: "https://www.youtube.com")!),
        FeedSource(name: "Google", url: URL(string: "https://www.google.com")!)
    ]

    func testArrayProperty() throws {
        FeedURLDatabase.array = []
        FeedURLDatabase.array = testArray
        XCTAssert(testArray.elementsEqual(FeedURLDatabase.array, by: ==))
    }

}
