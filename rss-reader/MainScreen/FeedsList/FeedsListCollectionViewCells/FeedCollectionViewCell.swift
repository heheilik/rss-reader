//
//  FeedCollectionViewCell.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 31.07.23.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    func updateContentsWith(_ text: String) {
        title.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.layer.borderColor = UIColor.systemGray.cgColor
                title.textColor = UIColor.systemGray
            } else {
                contentView.layer.borderColor = UIColor.systemBlue.cgColor
                title.textColor = UIColor.systemBlue
            }
        }
    }
    
}
