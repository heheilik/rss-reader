//
//  FeedsListTableViewCell.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 13.08.23.
//

import UIKit

class FeedSourcesListTableViewCell: UITableViewCell {
    
    let viewController = FeedSourcesListViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UINib(
            nibName: "FeedSourcesListViewController",
            bundle: nil
        ).instantiate(withOwner: viewController)
        contentView.addSubview(viewController.view)
    }
    
}
