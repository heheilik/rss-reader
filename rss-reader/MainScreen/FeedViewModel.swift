//
//  FeedViewModel.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 28.08.23.
//

import UIKit

class FeedViewModel: NSObject {

    func constraintsFor(
        contentView: UIView,
        entriesView: UIView,
        feedSourcesView: UIView,
        aboveSafeAreaCoverView: UIView
    ) -> [NSLayoutConstraint] {
        [
            entriesView.topAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.topAnchor
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

            feedSourcesView.leadingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.leadingAnchor
            ),
            feedSourcesView.trailingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.trailingAnchor
            ),
            feedSourcesView.bottomAnchor.constraint(
                equalTo: aboveSafeAreaCoverView.bottomAnchor,
                constant: 64
            ),
            feedSourcesView.heightAnchor.constraint(equalToConstant: 64),

            aboveSafeAreaCoverView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            aboveSafeAreaCoverView.bottomAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.topAnchor
            ),
            aboveSafeAreaCoverView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            aboveSafeAreaCoverView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            )
        ]
    }

    // MARK: - Scrolling

    enum ContentOffsetState {
        case normal
        case aboveTop     // Top point: scrollView.contentOffset.y >= 0
        case belowBottom  // Bottom point: scrollView.contentSize.height - scrollView.frame.size.height
    }

    var previousState = ContentOffsetState.normal
    var previousOffset: Double = 0

    var heightShown: Double = 64
}

extension FeedViewModel: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topPoint = scrollView.adjustedContentInset.top
        let bottomPoint = scrollView.contentSize.height - scrollView.frame.size.height

        let offset = scrollView.contentOffset.y

        let state: ContentOffsetState
        if offset < topPoint {
            state = .aboveTop
        } else if offset > scrollView.contentSize.height - scrollView.frame.size.height {
            state = .belowBottom
        } else {
            state = .normal
        }

//        print("State: \(state)")
//        print("Offset: \(offset)")
//        print("Previous Offset: \(previousOffset)")

        let delta = offset - previousOffset
//        print(delta)
//        print("")

        switch state {
        case .aboveTop:
            heightShown = max(0, heightShown - delta)

        case .normal:
            heightShown = max(0, min(64, heightShown - delta))

        case .belowBottom:
            heightShown = min(heightShown, max(0, heightShown - delta))
        }

        previousOffset = offset
        previousState = state
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // scrolling stopped
    }

}
