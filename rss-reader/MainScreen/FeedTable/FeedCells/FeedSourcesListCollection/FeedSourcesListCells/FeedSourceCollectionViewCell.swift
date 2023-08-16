//
//  FeedSourceCollectionViewCell.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 31.07.23.
//

import UIKit

class FeedSourceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    func updateContentsWith(_ text: String) {
        title.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    override func awakeFromNib() {
        contentView.layer.borderColor = CellAppearance.cellColor.cgColor
        contentView.layer.borderWidth = CellAppearance.borderWidth
        contentView.layer.cornerRadius = CellAppearance.cornerRadius
        title.textColor = CellAppearance.cellColor
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.layer.borderColor = CellAppearance.cellColorSelected.cgColor
                title.textColor = CellAppearance.cellColorSelected
            } else {
                contentView.layer.borderColor = CellAppearance.cellColor.cgColor
                title.textColor = CellAppearance.cellColor
            }
        }
    }
    
}
