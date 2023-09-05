//
//  FeedDragDropController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 18.08.23.
//

import UIKit

enum DragDropTypeIdentifier {
    static let feedCell = "Feed Cell"
}

// TODO: rename
class FeedDragDropController: NSObject {

    var observers: [String: FeedDragDropObserver] = [:]

    enum EventType {
        case dragDropStarted
        case dragDropEnded
        case itemMoved(IndexPath, IndexPath)
        case itemsDeleted([NSNumber])
    }

    func sendEvent(_ event: EventType) {
        switch event {
        case .dragDropStarted:
            for observer in observers.values {
                observer.onDragDropStarted()
            }
        case .dragDropEnded:
            for observer in observers.values {
                observer.onDragDropEnded()
            }
        case .itemMoved(let source, let destination):
            for observer in observers.values {
                observer.onItemMoved(from: source, to: destination)
            }
        case .itemsDeleted(let indicesToDelete):
            for observer in observers.values {
                observer.onItemsDeleted(withIndices: indicesToDelete)
            }
        }
    }

}

protocol FeedDragDropObserver {

    var dragDropObserverIdentifier: String { get }

    func onDragDropStarted()
    func onDragDropEnded()
    func onItemMoved(from source: IndexPath, to destination: IndexPath)
    func onItemsDeleted(withIndices indices: [NSNumber])

}
extension FeedDragDropObserver {
    func onDragDropStarted() {}
    func onDragDropEnded() {}
    func onItemMoved(from source: IndexPath, to destination: IndexPath) {}
    func onItemsDeleted(withIndices indices: [NSNumber]) {}
}

extension FeedDragDropController: UICollectionViewDragDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        guard let typedSection = FeedSourcesSection(rawValue: indexPath.section) else {
            fatalError("Section \(indexPath.section) is invalid.")
        }

        switch typedSection {
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
        sendEvent(.dragDropStarted)
    }

    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        sendEvent(.dragDropEnded)
    }

}

extension FeedDragDropController: UICollectionViewDropDelegate {

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
            guard session.items.count == 1 else {
                return .forbidden
            }

            guard
                let destinationIndexPath,
                let section = FeedSourcesSection(rawValue: destinationIndexPath.section)
            else {
                return .forbidden
            }

            switch section {
            case .plusButton:
                return .forbidden
            case .feeds:
                return .move
            }
        }()
        return UICollectionViewDropProposal(operation: operation, intent: .insertAtDestinationIndexPath)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        performDropWith coordinator: UICollectionViewDropCoordinator
    ) {
        guard
            coordinator.items.count == 1,
            let item = coordinator.items.first
        else {
            return
        }

        guard
            let sourceIndexPath = item.sourceIndexPath,
            let destinationIndexPath = coordinator.destinationIndexPath
        else {
            return
        }

        sendEvent(.itemMoved(sourceIndexPath, destinationIndexPath))
        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
    }

}

extension FeedDragDropController: UIDropInteractionDelegate {

    func dropInteraction(
        _ interaction: UIDropInteraction,
        canHandle session: UIDropSession
    ) -> Bool {
        session.hasItemsConforming(toTypeIdentifiers: [DragDropTypeIdentifier.feedCell])
    }

    func dropInteraction(
        _ interaction: UIDropInteraction,
        sessionDidUpdate session: UIDropSession
    ) -> UIDropProposal {
        UIDropProposal(operation: .move)
    }

    func dropInteraction(
        _ interaction: UIDropInteraction,
        performDrop session: UIDropSession
    ) {
        var indicesToDelete = [NSNumber]()
        for item in session.items {
            guard let localObject = item.localObject as? NSNumber else {
                fatalError("""
                    This view can accept items only with \(DragDropTypeIdentifier.feedCell) type identifier.
                """)
            }
            indicesToDelete.append(localObject)
        }
        sendEvent(.itemsDeleted(indicesToDelete))
    }

}
