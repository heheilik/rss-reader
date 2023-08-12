//
//  FeedURLDatabaseTest.swift
//  rss-reader-tests
//
//  Created by Heorhi Heilik on 12.08.23.
//

import XCTest

final class FeedURLDatabaseTest: XCTestCase {
    
    let testArray = [
        ("Swift Feed", URL(string: "https://www.swift.org/atom.xml")!),
        ("YouTube", URL(string: "https://www.youtube.com")!),
        ("Google", URL(string: "https://www.google.com")!)
    ]
    
    func testArrayProperty() throws {
        FeedURLDatabase.array = testArray
        XCTAssert(testArray.elementsEqual(FeedURLDatabase.array, by: ==))
    }

}
