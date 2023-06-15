//
//  TableViewCell.swift
//  rsa-reader
//
//  Created by Heorhi Heilik on 13.06.23.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak private var centerLabel: UILabel!

    func updateContents(centerLabelText: String) {
        centerLabel.text = centerLabelText
    }
    
}
