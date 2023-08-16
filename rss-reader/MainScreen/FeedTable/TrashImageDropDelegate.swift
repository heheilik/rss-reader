//
//  TrashIconDropDelegate.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 16.08.23.
//

import UIKit

class TrashImageDropDelegate: NSObject {
    
    var onDeleteDropSucceeded: (NSNumber) -> Void = { _ in }
    
}

extension TrashImageDropDelegate: UIDropInteractionDelegate {
    
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
        for item in session.items {
            guard let feedIndex = item.localObject as? NSNumber else {
                fatalError("""
                    This view can accept items only with \(DragDropTypeIdentifier.feedCell) type identifier.
                """)
            }
            onDeleteDropSucceeded(feedIndex)
        }
    }
    
}
