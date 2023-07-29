//
//  RssInfoTableViewCell.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 6.07.23.
//

import UIKit

class RssInfoTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var author: UILabel!
    @IBOutlet private weak var updated: UILabel!
    @IBOutlet private weak var id: UILabel!
    
    func updateContentsWith(_ entry: Entry) {
        title.text = entry.title
        author.text = entry.author
        updated.text = entry.updated
        id.text = entry.id
    }
    
}
