//
//  FeedsListViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 13.08.23.
//

import UIKit

class FeedsListViewModel {
    
    var feedsCount: Int {
        FeedURLDatabase.array.count
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
    
}
