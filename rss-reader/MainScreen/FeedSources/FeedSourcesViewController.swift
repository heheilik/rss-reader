//
//  FeedSourcesViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 13.08.23.
//

import UIKit

protocol FeedSourcesURLListDelegate: AnyObject {
    func onUrlSetUpdated(set: Set<URL>)
}

class FeedSourcesViewController: UIViewController {

    typealias FeedSourcesSection = FeedSourcesViewModel.FeedSourcesSection

    let viewModel = FeedSourcesViewModel()

    weak var urlListDelegate: FeedSourcesURLListDelegate?

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        collectionView.collectionViewLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            return layout
        }()

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(
            nib: UINib(nibName: "AddFeedSourceCollectionViewCell", bundle: nil),
            for: AddFeedSourceCollectionViewCell.self
        )
        collectionView.register(
            nib: UINib(nibName: "FeedSourceCollectionViewCell", bundle: nil),
            for: FeedSourceCollectionViewCell.self
        )

        collectionView.allowsMultipleSelection = true
    }
}

extension FeedSourcesViewController: UICollectionViewDataSource {

    // MARK: - Data Source

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        FeedSourcesSection.allCases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        let typedSection = viewModel.section(forIndexPath: IndexPath(row: 0, section: section))
        return viewModel.itemCount(for: typedSection)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let typedSection = viewModel.section(forIndexPath: indexPath)
        switch typedSection {
        case .plusButton:
            return collectionView.dequeue(
                AddFeedSourceCollectionViewCell.self,
                for: indexPath
            ) { cell in

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
            }

        case .feeds:
            return collectionView.dequeue(
                FeedSourceCollectionViewCell.self,
                for: indexPath
            ) { cell in
                cell.updateContentsWith(viewModel.feedName(for: indexPath))
            }
        }
    }

}

extension FeedSourcesViewController: UICollectionViewDelegateFlowLayout {

    // MARK: - Size Calculations

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let typedSection = viewModel.section(forIndexPath: indexPath)
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
        let typedSection = viewModel.section(forIndex: section)
        switch typedSection {
        case .plusButton:
            return UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0
            )
        case .feeds:
            return UIEdgeInsets(
                top: 0,
                left: 8,
                bottom: 0,
                right: 0
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
        let typedSection = viewModel.section(forIndexPath: indexPath)
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
        urlListDelegate?.onUrlSetUpdated(
            set: viewModel.urlSetFor(
                selectionArray: collectionView.indexPathsForSelectedItems ?? []
            )
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        urlListDelegate?.onUrlSetUpdated(
            set: viewModel.urlSetFor(
                selectionArray: collectionView.indexPathsForSelectedItems ?? []
            )
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        urlListDelegate?.onUrlSetUpdated(
            set: viewModel.urlSetFor(
                selectionArray: collectionView.indexPathsForSelectedItems ?? []
            )
        )
    }

}

extension FeedSourcesViewController: FeedDragDropObserver {

    var dragDropObserverIdentifier: String {
        "FeedSourcesViewController"
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

        urlListDelegate?.onUrlSetUpdated(
            set: viewModel.urlSetFor(
                selectionArray: collectionView.indexPathsForSelectedItems ?? []
            )
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

        urlListDelegate?.onUrlSetUpdated(
            set: viewModel.urlSetFor(
                selectionArray: collectionView.indexPathsForSelectedItems ?? []
            )
        )
    }

}