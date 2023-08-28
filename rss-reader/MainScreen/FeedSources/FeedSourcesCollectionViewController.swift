//
//  FeedSourcesCollectionViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 13.08.23.
//

import UIKit

enum FeedSourcesSection: Int, CaseIterable {
    case plusButton = 0
    case feeds
}

protocol FeedSourcesSelectionDelegate: AnyObject {
    func onCellSelectionArrayProbablyChanged(selectionArray: [IndexPath])
}

class FeedSourcesCollectionViewController: UIViewController {

    let viewModel = FeedSourcesCollectionViewModel()

    @IBOutlet weak var collectionView: UICollectionView!

    enum CellIdentifier {
        static let plusButton = "AddFeedSourceCollectionViewCell"
        static let feed = "FeedSourceCollectionViewCell"
    }

    override var view: UIView! {
        didSet {
            configureCollectionView()
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

    weak var selectionDelegate: FeedSourcesSelectionDelegate?

}

extension FeedSourcesCollectionViewController: UICollectionViewDataSource {

    // MARK: - Data Source

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        FeedSourcesSection.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let typedSection = FeedSourcesSection.init(rawValue: section) else {
            fatalError("Section \(section) is invalid.")
        }
        return viewModel.itemCount(for: typedSection)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let typedSection = FeedSourcesSection.init(rawValue: indexPath.section) else {
            fatalError("Section \(indexPath.section) is invalid.")
        }

        switch typedSection {
        case .plusButton:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CellIdentifier.plusButton,
                for: indexPath
            ) as? AddFeedSourceCollectionViewCell else {
                fatalError("Failed to dequeue (\(CellIdentifier.plusButton)).")
            }

            let plusButtonUIAction = UIAction { _ in
                let addFeedSourceViewController = AddFeedSourceViewController()
                addFeedSourceViewController.sheetPresentationController?.detents = [.medium()]
                addFeedSourceViewController.saveDataCallback = { feedSource in
                    self.collectionView.performBatchUpdates {
                        let indexPath = IndexPath(
                            row: self.viewModel.itemCount(for: FeedSourcesSection.feeds),
                            section: FeedSourcesSection.feeds.rawValue
                        )
                        self.viewModel.collectionView(
                            self.collectionView,
                            willInsertItem: feedSource,
                            at: indexPath
                        )
                        self.collectionView.insertItems(at: [indexPath])
                    }
                }
                self.present(addFeedSourceViewController, animated: true)
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

extension FeedSourcesCollectionViewController: UICollectionViewDelegateFlowLayout {

    // MARK: - Size Calculations

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let typedSection = FeedSourcesSection(rawValue: indexPath.section) else {
            fatalError("Wrong section.")
        }
        switch typedSection {
        case .plusButton:
            return viewModel.plusButtonSize(collectionView: collectionView)
        case .feeds:
            return viewModel.feedSourceSize(collectionView: collectionView, amountOfFeedsOnScreen: 3)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        guard let typedSection = FeedSourcesSection(rawValue: section) else {
             fatalError("Section \(section) is invalid.")
        }
        switch typedSection {
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
        guard let typedSection = FeedSourcesSection(rawValue: indexPath.section) else {
            fatalError("Section \(indexPath.section) is invalid.")
        }
        switch typedSection {
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
        selectionDelegate?.onCellSelectionArrayProbablyChanged(
            selectionArray: collectionView.indexPathsForSelectedItems ?? []
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        selectionDelegate?.onCellSelectionArrayProbablyChanged(
            selectionArray: collectionView.indexPathsForSelectedItems ?? []
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        selectionDelegate?.onCellSelectionArrayProbablyChanged(
            selectionArray: collectionView.indexPathsForSelectedItems ?? []
        )
    }

}

extension FeedSourcesCollectionViewController: FeedDragDropObserver {

    var dragDropObserverIdentifier: String {
        "FeedSourcesCollectionViewController"
    }

    func onItemMoved(from source: IndexPath, to destination: IndexPath) {
        collectionView.performBatchUpdates {
            viewModel.collectionView(
                collectionView,
                willMoveItemAt: source,
                to: destination
            )
            collectionView.moveItem(at: source, to: destination)
        }

        selectionDelegate?.onCellSelectionArrayProbablyChanged(
            selectionArray: collectionView.indexPathsForSelectedItems ?? []
        )
    }

    func onItemsDeleted(withIndices indices: [NSNumber]) {
        var indexPathsToDelete = [IndexPath]()
        for index in indices {
            let indexPath = IndexPath(
                row: index.intValue,
                section: FeedSourcesSection.feeds.rawValue
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

        selectionDelegate?.onCellSelectionArrayProbablyChanged(
            selectionArray: collectionView.indexPathsForSelectedItems ?? []
        )
    }

}
