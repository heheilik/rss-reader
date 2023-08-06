//
//  AddFeedCollectionViewCell.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 31.07.23.
//

import UIKit

class AddFeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var plusButton: UIButton!
    
    override func prepareForReuse() {
        plusButton.removeTarget(nil, action: nil, for: .touchUpInside)
    }
    
}
