//
//  FeedSourcesListViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 13.08.23.
//

import UIKit

class FeedSourcesListViewController: UIViewController {
    
    let viewModel = FeedsListViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    enum SectionIndex: Int {
        case plusButton = 0
        case feeds = 1
    }
    
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
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        
        collectionView.register(
            UINib(nibName: CellIdentifier.plusButton, bundle: nil),
            forCellWithReuseIdentifier: CellIdentifier.plusButton
        )
        collectionView.register(
            UINib(nibName: CellIdentifier.feed, bundle: nil),
            forCellWithReuseIdentifier: CellIdentifier.feed
        )
    }
    
    func setCallbacks() {
        onDeleteDropSucceeded = { feedIndex in
            DispatchQueue.main.async {
                self.collectionView.performBatchUpdates {
                    let indexPath = IndexPath(
                        row: Int(truncating: feedIndex),
                        section: SectionIndex.feeds.rawValue
                    )
                    self.viewModel.collectionView(
                        self.collectionView,
                        willDeleteItemsAt: [indexPath]
                    )
                    self.collectionView.deleteItems(at: [indexPath])
                }
            }
        }
        
        addFeedSourceCallback = { feedSource in
            self.collectionView.performBatchUpdates {
                let indexPath = IndexPath(
                    row: self.viewModel.feedsCount,
                    section: SectionIndex.feeds.rawValue
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
    
    var onDragAndDropStarted: () -> Void = {}
    var onDragAndDropFinished: () -> Void = {}
    
    private(set) var onDeleteDropSucceeded: (NSNumber) -> Void = { _ in }
    
}

extension FeedSourcesListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let section = SectionIndex.init(rawValue: section) else {
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
        guard let section = SectionIndex.init(rawValue: indexPath.section) else {
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
        
        if indexPath.section == SectionIndex.plusButton.rawValue {
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
        guard let section = SectionIndex(rawValue: section) else {
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
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let section = SectionIndex(rawValue: indexPath.section) else {
            fatalError("Section \(indexPath.section) is invalid.")
        }
        switch section {
        case .plusButton:
            return false
        case .feeds:
            return !(collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false)
        }
    }
    
    #warning("Rewrite item selection actions.")
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item selected. \(indexPath)")
    }
    
}

extension FeedSourcesListViewController: UICollectionViewDragDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        guard let section = SectionIndex(rawValue: indexPath.section) else {
            fatalError("Section \(indexPath.section) is invalid.")
        }
        
        switch section {
        case .plusButton:
            return []
        case .feeds:
            let data = indexPath.row
            let objProvider = NSItemProvider(
                item: NSNumber(value: data),
                typeIdentifier: DragDropTypeIdentifier.feedCell
            )
            let item = UIDragItem(itemProvider: objProvider)
            item.localObject = data
            
            return [item]
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        onDragAndDropStarted()
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        onDragAndDropFinished()
    }
    
}

extension FeedSourcesListViewController: UICollectionViewDropDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        canHandle session: UIDropSession
    ) -> Bool {
        session.hasItemsConforming(toTypeIdentifiers: [DragDropTypeIdentifier.feedCell])
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UICollectionViewDropProposal {
        let operation: UIDropOperation = {
            if let destinationIndexPath, destinationIndexPath.section != SectionIndex.plusButton.rawValue {
                return .move
            } else {
                return .forbidden
            }
        }()
        return UICollectionViewDropProposal(operation: operation, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator
    ) {
        for item in coordinator.items {
            guard
                let sourceIndexPath = item.sourceIndexPath,
                let destinationIndexPath = coordinator.destinationIndexPath
            else {
                continue
            }
    
            collectionView.performBatchUpdates {
                viewModel.collectionView(
                    collectionView,
                    willMoveItemAt: sourceIndexPath,
                    to: destinationIndexPath
                )
                collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
            }
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
    
}
