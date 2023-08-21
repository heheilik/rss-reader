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
    @IBOutlet private weak var updated: UILabel!
    @IBOutlet private weak var id: UILabel!
    
    func updateContentsWith(_ entryHeader: Entry.Header) {
        title.text = entryHeader.title.trimmingCharacters(in: .whitespacesAndNewlines)
        author.text = entryHeader.author.trimmingCharacters(in: .whitespacesAndNewlines)
        updated.text = entryHeader.updated.trimmingCharacters(in: .whitespacesAndNewlines)
        id.text = entryHeader.id.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
