//
//  FeedSourcesSectionViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 28.08.23.
//

import Foundation

class FeedSourcesSectionViewModel {

    var isDeleteActive = false

    func rowCount(for section: TableSection) -> Int {
        switch section {
        case .feedSources:
            return 1
        case .trashIcon:
            return isDeleteActive ? 1 : 0
        case .status, .entries:
            fatalError("Section \(section) is not managed by this class.")
        }
    }

}
