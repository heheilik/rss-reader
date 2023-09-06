//
//  UITableView+Extensions.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 5.09.23.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension UITableView {
    func register<Cell: UITableViewCell>(nib: UINib, for cell: Cell.Type) {
        self.register(nib, forCellReuseIdentifier: cell.reuseIdentifier)
    }

    func dequeue<Cell: UITableViewCell>(
        _ cellType: Cell.Type,
        for indexPath: IndexPath,
        configure: (inout Cell) -> Void
    ) -> UITableViewCell {
        let cell = dequeueReusableCell(
            withIdentifier: cellType.reuseIdentifier,
            for: indexPath
        )

        guard var cell = cell as? Cell else {
            assertionFailure("Cell can't be cast to type \(cellType).")
            return cell
        }

        configure(&cell)
        return cell
    }
}
