//
//  FeedViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 28.08.23.
//

import UIKit

class FeedViewModel {

    func constraintsFor(
        contentView: UIView,
        feedSourcesView: UIView,
        entriesView: UIView
    ) -> [NSLayoutConstraint] {
        [
            feedSourcesView.topAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.topAnchor
            ),
            feedSourcesView.leadingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.leadingAnchor
            ),
            feedSourcesView.trailingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.trailingAnchor
            ),
            entriesView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),
            entriesView.leadingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.leadingAnchor
            ),
            entriesView.trailingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.trailingAnchor
            ),
            feedSourcesView.bottomAnchor.constraint(
                equalTo: entriesView.topAnchor,
                constant: -8
            ),
            feedSourcesView.heightAnchor.constraint(equalToConstant: 64)
        ]
    }

    // TODO: Rename
//    enum TableSizeConstant {
//        static let feedsListHeight: CGFloat = 64
//        static let trashIconHeight: CGFloat = 64
//        static let bottomInset: CGFloat = 8
//    }

//    func tableView(
//        _ tableView: UITableView,
//        contentHeightForSection section: TableSection,
//        isTrashIconActive: Bool
//    ) -> CGFloat {
//        switch section {
//        case .feedSources:
//            return feedsListTotalHeight()
//        case .trashIcon:
//            return trashIconTotalHeight()
//        case .status:
//            return tableContentHeight(
//                totalHeight: tableView.bounds.height,
//                isTrashIconActive: isTrashIconActive
//            )
//        case .entries:
//            return UITableView.automaticDimension
//        }
//    }
//
//    private func tableContentHeight(totalHeight: CGFloat, isTrashIconActive: Bool) -> CGFloat {
//        var result = totalHeight
//        result -= feedsListTotalHeight()
//        if isTrashIconActive {
//            result -= trashIconTotalHeight()
//        }
//        return result
//    }
//
//    private func feedsListTotalHeight() -> CGFloat {
//        TableSizeConstant.feedsListHeight + TableSizeConstant.bottomInset
//    }
//    private func trashIconTotalHeight() -> CGFloat {
//        TableSizeConstant.trashIconHeight + TableSizeConstant.bottomInset
//    }

}
