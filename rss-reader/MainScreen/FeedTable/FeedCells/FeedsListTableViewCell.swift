//
//  FeedsListTableViewCell.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 13.08.23.
//

import UIKit

class FeedsListTableViewCell: UITableViewCell {
    
    let collectionViewController = FeedsListViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UINib(
            nibName: "FeedsListViewController",
            bundle: nil
        ).instantiate(withOwner: collectionViewController)
        #warning("Check necessity.")
        contentView.addSubview(collectionViewController.view)
    }
    
}
