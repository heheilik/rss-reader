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
    
    let dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    
    func updateContentsWith(_ entryHeader: FormattedEntry.Header) {
        title.text = entryHeader.title
        author.text = entryHeader.author
        updated.text = dateFormatter.string(from: entryHeader.updated)
        id.text = entryHeader.id
    }
    
}
