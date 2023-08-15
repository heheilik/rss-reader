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
    
    override func awakeFromNib() {
        trashImageView.tintColor = CellAppearance.trashColor
        trashImageBorderView.layer.borderColor = CellAppearance.trashColor.cgColor
        trashImageBorderView.layer.borderWidth = CellAppearance.borderWidth
        trashImageBorderView.layer.cornerRadius = CellAppearance.cornerRadius
    }
    
}
