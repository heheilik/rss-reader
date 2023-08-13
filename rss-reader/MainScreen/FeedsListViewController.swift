//
//  FeedsListViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 13.08.23.
//

import UIKit

class FeedsListViewController: UIViewController {
    
    let viewModel = FeedsListViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override var view: UIView! {
        didSet {
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
                UINib(nibName: "AddFeedCollectionViewCell", bundle: nil),
                forCellWithReuseIdentifier: "AddFeedCollectionViewCell"
            )
            collectionView.register(
                UINib(nibName: "FeedCollectionViewCell", bundle: nil),
                forCellWithReuseIdentifier: "FeedCollectionViewCell"
            )
        }
    }
    
}

extension FeedsListViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 1 + FeedURLDatabase.array.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "AddFeedCollectionViewCell",
                for: indexPath
            ) as? AddFeedCollectionViewCell else {
                fatalError("Failed to dequeue (ViewController.feedCollection).")
            }
            
//            let plusButtonAction = UIAction { _ in
//                let addFeedViewController = AddFeedViewController()
//                addFeedViewController.sheetPresentationController?.detents = [.medium()]
//                addFeedViewController.saveDataCallback = { name, url in
//                    FeedURLDatabase.array.append((name, url))
//                    self.collectionView.reloadData()
//                }
//                self.present(addFeedViewController, animated: true)
//            }
//            cell.plusButton.addAction(plusButtonAction, for: .touchUpInside)
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "FeedCollectionViewCell",
            for: indexPath
        ) as? FeedCollectionViewCell else {
            fatalError("Failed to dequeue (ViewController.feedCollection).")
        }
        
        cell.updateContentsWith(FeedURLDatabase.array[indexPath.row - 1].name)
        cell.isSelected = false
        #warning("Rewrite selection behaviour.")
        
        return cell
    }
    
}

extension FeedsListViewController: UICollectionViewDelegateFlowLayout {
    
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
        
        if indexPath.row == 0 {
            return plusSize
        }
        
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
        UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0 && !(collectionView.cellForItem(at: indexPath)?.isSelected ?? true)
    }
    
    #warning("Rewrite")
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item selected. \(indexPath)")
    }
    
}

extension FeedsListViewController: UICollectionViewDragDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        if indexPath.row == 0 {
            return []
        }
        
        let data = indexPath.row - 1
        
        let objProvider = NSItemProvider(
            item: NSNumber(value: data),
            typeIdentifier: "feedIndex"
        )
        
        let item = UIDragItem(itemProvider: objProvider)
        item.localObject = data
        
        return [item]
    }
    
}

extension FeedsListViewController: UICollectionViewDropDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        canHandle session: UIDropSession
    ) -> Bool {
        session.hasItemsConforming(toTypeIdentifiers: ["feedIndex"])
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UICollectionViewDropProposal {
        let operation: UIDropOperation = {
            if let destinationIndexPath, destinationIndexPath.row != 0 {
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
                let element = FeedURLDatabase.array.remove(at: sourceIndexPath.row - 1)
                FeedURLDatabase.array.insert(element, at: destinationIndexPath.row - 1)
                collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
            }
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
    
}
