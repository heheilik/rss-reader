//
//  UICollectionView+Extensions.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 6.09.23.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension UICollectionView {
    func register<Cell: UICollectionViewCell>(nib: UINib, for cell: Cell.Type) {
        self.register(nib, forCellWithReuseIdentifier: cell.reuseIdentifier)
    }

    func dequeue<Cell: UICollectionViewCell>(
        _ cellType: Cell.Type,
        for indexPath: IndexPath,
        configure: (inout Cell) -> Void
    ) -> UICollectionViewCell {
        let cell = dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
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
