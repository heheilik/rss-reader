//
//  FeedsListTableViewCell.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 13.08.23.
//

import UIKit

class FeedSourcesListTableViewCell: UITableViewCell {

    var viewController: FeedSourcesViewController? {
        didSet {
            guard let viewController else {
                return
            }
            contentView.addSubview(viewController.view)
        }
    }

}
