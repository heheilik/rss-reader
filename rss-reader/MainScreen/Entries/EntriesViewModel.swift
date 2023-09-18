//
//  EntriesViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 5.09.23.
//

import Foundation

final class EntriesViewModel {

    enum TableSection: Int, CaseIterable {
        case feedSourcesPlaceholder
        case status
        case entries
    }

    func sectionCount() -> Int {
        TableSection.allCases.count
    }

    func section(forIndexPath indexPath: IndexPath) -> TableSection {
        guard let section = TableSection(rawValue: indexPath.section) else {
            fatalError("Section for cell at \(indexPath) does not exist.")
        }
        return section
    }

    func section(forIndex index: Int) -> TableSection {
        guard let section = TableSection(rawValue: index) else {
            fatalError("Section for index \(index) does not exist.")
        }
        return section
    }

}
