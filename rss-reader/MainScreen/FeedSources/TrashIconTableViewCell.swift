//
//  TrashIconTableViewCell.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 13.08.23.
//

import UIKit

class TrashIconTableViewCell: UITableViewCell {

    @IBOutlet weak var trashImageView: UIImageView!
    @IBOutlet weak var trashImageBorderView: UIView!

    var trashImageDropDelegate: FeedDragDropController? {
        didSet {
            trashImageBorderView.interactions = []
            if let trashImageDropDelegate {
                trashImageBorderView.interactions = [UIDropInteraction(delegate: trashImageDropDelegate)]
            }
        }
    }

    override func awakeFromNib() {
        configureAppearance()
    }

    private func configureAppearance() {
        trashImageView.tintColor = Constants.CellAppearance.trashColor
        trashImageBorderView.layer.borderColor = Constants.CellAppearance.trashColor.cgColor
        trashImageBorderView.layer.borderWidth = Constants.CellAppearance.borderWidth
        trashImageBorderView.layer.cornerRadius = Constants.CellAppearance.cornerRadius
        selectionStyle = .none
    }

}
