//
//  FeedsCollectionViewLayout.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 4.08.23.
//

import UIKit

class FeedsCollectionViewLayout: UICollectionViewFlowLayout {
    
    private let minimumCellWidth: CGFloat = 200.0
    private let cellHeight: CGFloat = 64.0
    
    private let plusSize = CGSize(width: 64, height: 64)
    
    override init() {
        super.init()
        scrollDirection = .horizontal
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FeedsCollectionViewLayout: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if indexPath.row == 0 {
            return plusSize
        }
        
        let width = collectionView.bounds.width
        print(width)
        return CGSize(width: (width - plusSize.width) / 2.5, height: 64)
    }
    
}
