//
//  FeedSourcesViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 13.08.23.
//

import UIKit

class FeedSourcesViewModel {

    enum FeedSourcesSection: Int, CaseIterable {
        case plusButton
        case feeds
    }

    func section(forIndexPath indexPath: IndexPath) -> FeedSourcesSection {
        guard let typedSection = FeedSourcesSection(rawValue: indexPath.section) else {
            fatalError("Section at \(indexPath) does not exist.")
        }
        return typedSection
    }

    func section(forIndex index: Int) -> FeedSourcesSection {
        guard let typedSection = FeedSourcesSection(rawValue: index) else {
            fatalError("Section at index \(index) does not exist.")
        }
        return typedSection
    }

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

    func urlSetFor(selectionArray: [IndexPath]) -> Set<URL> {
        var result = Set<URL>()

        for indexPath in selectionArray {
            let typedSection = section(forIndexPath: indexPath)
            switch typedSection {
            case .feeds:
                result.insert(FeedURLDatabase.array[indexPath.row].url)
            case .plusButton:
                continue
            }
        }

        return result
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

        guard
            let inset = delegate.collectionView?(
                collectionView,
                layout: collectionView.collectionViewLayout,
                insetForSectionAt: FeedSourcesSection.feeds.rawValue
            ),
            let spacing = delegate.collectionView?(
                collectionView,
                layout: collectionView.collectionViewLayout,
                minimumInteritemSpacingForSectionAt: FeedSourcesSection.feeds.rawValue
            )
        else {
            fatalError("Required methods of delegate are not implemented.")
        }

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
