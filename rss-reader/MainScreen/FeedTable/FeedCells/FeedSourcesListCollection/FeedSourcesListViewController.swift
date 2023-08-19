//
//  FeedSourcesListViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 13.08.23.
//

import UIKit

enum FeedSourcesSectionIndex: Int {
    case plusButton = 0
    case feeds = 1
}

class FeedSourcesListViewController: UIViewController {
    
    let viewModel = FeedsListViewModel()
    
    static let feedDragDropObserverIdentifier = "FeedSources"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum CellIdentifier {
        static let plusButton = "AddFeedSourceCollectionViewCell"
        static let feed = "FeedSourceCollectionViewCell"
    }
    
    override var view: UIView! {
        didSet {
            configureCollectionView()
            setCallbacks()
        }
    }
    
    func configureCollectionView() {
        collectionView.collectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            return layout
        }()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            UINib(nibName: CellIdentifier.plusButton, bundle: nil),
            forCellWithReuseIdentifier: CellIdentifier.plusButton
        )
        collectionView.register(
            UINib(nibName: CellIdentifier.feed, bundle: nil),
            forCellWithReuseIdentifier: CellIdentifier.feed
        )
        
        collectionView.allowsMultipleSelection = true
    }
    
    func setCallbacks() {
        addFeedSourceCallback = { feedSource in
            self.collectionView.performBatchUpdates {
                let indexPath = IndexPath(
                    row: self.viewModel.feedsCount,
                    section: FeedSourcesSectionIndex.feeds.rawValue
                )
                self.viewModel.collectionView(
                    self.collectionView,
                    willInsertItem: feedSource,
                    at: indexPath
                )
                self.collectionView.insertItems(at: [indexPath])
            }
        }
    }
    
    private var addFeedSourceCallback: (FeedSource) -> Void = { _ in }
    
    var onCellSelectionArrayChanged: ([IndexPath]?) -> Void = { _ in }
    
}

extension FeedSourcesListViewController: UICollectionViewDataSource {
    
    // MARK: - Data Source
    
    #warning("Create a constant.")
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let section = FeedSourcesSectionIndex.init(rawValue: section) else {
            fatalError("Section \(section) is invalid.")
        }
        
        switch section {
        case .plusButton:
            return 1
        case .feeds:
            return viewModel.feedsCount
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let section = FeedSourcesSectionIndex.init(rawValue: indexPath.section) else {
            fatalError("Section \(indexPath.section) is invalid.")
        }
        
        switch section {
        case .plusButton:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CellIdentifier.plusButton,
                for: indexPath
            ) as? AddFeedSourceCollectionViewCell else {
                fatalError("Failed to dequeue (\(CellIdentifier.plusButton)).")
            }
            
            let plusButtonUIAction = UIAction { _ in
                let addFeedViewController = AddFeedSourceViewController()
                addFeedViewController.sheetPresentationController?.detents = [.medium()]
                addFeedViewController.saveDataCallback = self.addFeedSourceCallback
                self.present(addFeedViewController, animated: true)
            }
            
            cell.plusButton.addAction(plusButtonUIAction, for: .touchUpInside)
            return cell
            
        case .feeds:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CellIdentifier.feed,
                for: indexPath
            ) as? FeedSourceCollectionViewCell else {
                fatalError("Failed to dequeue (\(CellIdentifier.feed)).")
            }
            
            cell.updateContentsWith(viewModel.feedName(for: indexPath))
            return cell
        }
    }
    
}

extension FeedSourcesListViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Size Calculations
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let inset = self.collectionView(
            collectionView,
            layout: collectionViewLayout,
            insetForSectionAt: indexPath.section
        )
        let spacing = self.collectionView(
            collectionView,
            layout: collectionViewLayout,
            minimumInteritemSpacingForSectionAt: indexPath.section
        )
        let contentHeight = collectionView.bounds.size.height
        let contentWidth = collectionView.bounds.size.width
        
        let plusSize = CGSize(width: contentHeight, height: contentHeight)
        
        if indexPath.section == FeedSourcesSectionIndex.plusButton.rawValue {
            return plusSize
        }
        
        #warning("Recalculate cell layout.")
        return CGSize(
            width: (contentWidth - plusSize.width - inset.left - 3 * spacing) / 2.5,
            height: contentHeight
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        guard let section = FeedSourcesSectionIndex(rawValue: section) else {
             fatalError("Section \(section) is invalid.")
        }
        switch section {
        case .plusButton:
            return UIEdgeInsets(
                top: 0,
                left: 8,
                bottom: 0,
                right: 0
            )
        case .feeds:
            return UIEdgeInsets(
                top: 0,
                left: 8,
                bottom: 0,
                right: 8
            )
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        8
    }
    
    
    // MARK: - Selection
    
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        guard let section = FeedSourcesSectionIndex(rawValue: indexPath.section) else {
            fatalError("Section \(indexPath.section) is invalid.")
        }
        switch section {
        case .plusButton:
            return false
        case .feeds:
            return true
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        onCellSelectionArrayChanged(collectionView.indexPathsForSelectedItems)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        onCellSelectionArrayChanged(collectionView.indexPathsForSelectedItems)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        onCellSelectionArrayChanged(collectionView.indexPathsForSelectedItems)
    }
    
}

extension FeedSourcesListViewController: FeedDragDropObserver {
    
    func onItemMoved(from source: IndexPath, to destination: IndexPath) {
        collectionView.performBatchUpdates {
            viewModel.collectionView(
                collectionView,
                willMoveItemAt: source,
                to: destination
            )
            collectionView.moveItem(at: source, to: destination)
        }
    }
    
    func onItemsDeleted(withIndices indices: [NSNumber]) {
        var indexPathsToDelete = [IndexPath]()
        for index in indices {
            let indexPath = IndexPath(
                row: index.intValue,
                section: FeedSourcesSectionIndex.feeds.rawValue
            )
            indexPathsToDelete.append(indexPath)
        }
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates {
                self.viewModel.collectionView(
                    self.collectionView,
                    willDeleteItemsAt: indexPathsToDelete
                )
                self.collectionView.deleteItems(at: indexPathsToDelete)
            }
        }
    }
    
}
