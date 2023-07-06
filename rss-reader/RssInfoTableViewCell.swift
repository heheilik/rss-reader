//
//  RssInfoTableViewCell.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 6.07.23.
//

import UIKit

class RssInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var updated: UILabel!
    @IBOutlet weak var id: UILabel!
    
    func updateContentsWith(
        title titleString: String?,
        author authorString: String?,
        updated updatedString: String?,
        id idString: String?
    ) {
        if let titleString {
            title.text = titleString
        }
        if let authorString {
            author.text = authorString
        }
        if let updatedString {
            updated.text = updatedString
        }
        if let idString {
            id.text = idString
        }
    }
    
}
