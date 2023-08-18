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
        trashImageView.tintColor = CellAppearance.trashColor
        trashImageBorderView.layer.borderColor = CellAppearance.trashColor.cgColor
        trashImageBorderView.layer.borderWidth = CellAppearance.borderWidth
        trashImageBorderView.layer.cornerRadius = CellAppearance.cornerRadius
        selectionStyle = .none
    }
    
}
