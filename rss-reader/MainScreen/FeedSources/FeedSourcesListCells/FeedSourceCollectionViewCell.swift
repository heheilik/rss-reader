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
        contentView.layer.borderColor = Constants.CellAppearance.cellColor.cgColor
        contentView.layer.borderWidth = Constants.CellAppearance.borderWidth
        contentView.layer.cornerRadius = Constants.CellAppearance.cornerRadius
        title.textColor = Constants.CellAppearance.cellColor
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.layer.borderColor = Constants.CellAppearance.cellColorSelected.cgColor
                title.textColor = Constants.CellAppearance.cellColorSelected
            } else {
                contentView.layer.borderColor = Constants.CellAppearance.cellColor.cgColor
                title.textColor = Constants.CellAppearance.cellColor
            }
        }
    }

}
