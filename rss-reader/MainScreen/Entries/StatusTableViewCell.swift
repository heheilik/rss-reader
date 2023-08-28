//
//  StartTableViewCell.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 16.08.23.
//

import UIKit

class StatusTableViewCell: UITableViewCell {

    @IBOutlet private weak var statusLabel: UILabel!

    enum Status: String {
        case start = "Choose one or multiple feeds to show."
        case loading = "Loading..."
    }

    override func awakeFromNib() {
        selectionStyle = .none
    }

    func setStatus(_ status: Status) {
        self.statusLabel.text = status.rawValue
    }

}
