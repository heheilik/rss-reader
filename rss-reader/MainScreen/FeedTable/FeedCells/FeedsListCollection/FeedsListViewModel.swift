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
    
    func feedNameFor(row: Int) -> String {
        return FeedURLDatabase.array[row].name
    }
    
    
    // MARK: - DragDrop operations
    
    func collectionView(
        _ collectionView: UICollectionView,
        movesItemFrom source: IndexPath,
        to destination: IndexPath
    ) {
        let element = FeedURLDatabase.array.remove(at: source.row)
        FeedURLDatabase.array.insert(element, at: destination.row)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        deletesItemAt indexPath: IndexPath
    ) {
        FeedURLDatabase.array.remove(at: indexPath.row)
        #warning("set update for FeedViewModel")
    }
    
}
