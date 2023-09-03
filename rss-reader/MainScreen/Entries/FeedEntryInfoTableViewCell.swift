//
//  FeedEntryInfoTableViewCell.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 6.07.23.
//

import UIKit

class FeedEntryInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var lastUpdated: UILabel!
    @IBOutlet private weak var identifier: UILabel!

    let dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()

    func updateContentsWith(_ entryHeader: EntryHeader) {
        title.text = entryHeader.title
        author.text = entryHeader.author
        if let date = entryHeader.lastUpdated {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            lastUpdated.text = dateFormatter.string(from: date)
        } else {
            lastUpdated.text = ""
        }
        identifier.text = entryHeader.identifier
    }

}
