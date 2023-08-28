//
//  FeedSourcesCollectionViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 13.08.23.
//

import UIKit

class FeedSourcesCollectionViewModel {

    func itemCount(for section: FeedSourcesSection) -> Int {
        switch section {
        case .plusButton:
            return 1
        case .feeds:
            return FeedURLDatabase.array.count
        }
    }

    func feedName(for indexPath: IndexPath) -> String {
        return FeedURLDatabase.array[indexPath.row].name
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willInsertItem item: FeedSource,
        at indexPath: IndexPath
    ) {
        FeedURLDatabase.array.insert(item, at: indexPath.row)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willMoveItemAt source: IndexPath,
        to destination: IndexPath
    ) {
        let element = FeedURLDatabase.array.remove(at: source.row)
        FeedURLDatabase.array.insert(element, at: destination.row)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDeleteItemsAt indexPaths: [IndexPath]
    ) {
        var set = IndexSet()
        for indexPath in indexPaths {
            set.insert(indexPath.row)
        }
        FeedURLDatabase.array.remove(atOffsets: set)
    }

    // MARK: - Size Calculation

    func plusButtonSize(collectionView: UICollectionView) -> CGSize {
        let height = collectionView.bounds.size.height
        return CGSize(width: height, height: height)
    }

    func feedSourceSize(
        collectionView: UICollectionView,
        amountOfFeedsOnScreen: CGFloat
    ) -> CGSize {
        guard let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else {
            fatalError("Wrong delegate.")
        }

        let inset = delegate.collectionView!(
            collectionView,
            layout: collectionView.collectionViewLayout,
            insetForSectionAt: TableSection.feedSources.rawValue
        )
        let spacing = delegate.collectionView!(
            collectionView,
            layout: collectionView.collectionViewLayout,
            minimumInteritemSpacingForSectionAt: TableSection.feedSources.rawValue
        )

        let contentWidth = collectionView.bounds.size.width
        let contentHeight = collectionView.bounds.size.height
        let plusWidth = plusButtonSize(collectionView: collectionView).width

        var cellWidth = contentWidth
        cellWidth -= inset.left + plusWidth
        cellWidth -= amountOfFeedsOnScreen * spacing

        cellWidth /= amountOfFeedsOnScreen - 0.5

        return CGSize(
            width: cellWidth,
            height: contentHeight
        )
    }

}
