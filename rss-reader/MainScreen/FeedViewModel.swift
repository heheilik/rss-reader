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
    var previousOffset: CGFloat = 0

    var heightShown: CGFloat = 64

}

extension FeedViewModel: UIScrollViewDelegate {

    func adjustHeight(
        _ height: inout CGFloat,
        forDelta delta: CGFloat,
        inRangeOfState state: ContentOffsetState
    ) {
        switch state {
        case .aboveTop:
            height = max(0, height - delta)

        case .normal:
            height = max(0, min(64, height - delta))

        case .belowBottom:
            height = min(height, max(0, height - delta))
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topPoint = scrollView.adjustedContentInset.top
        let bottomPoint = scrollView.contentSize.height - scrollView.frame.size.height

        let offset = scrollView.contentOffset.y

        let state: ContentOffsetState
        if offset < topPoint {
            state = .aboveTop
        } else if offset > bottomPoint {
            state = .belowBottom
        } else {
            state = .normal
        }

        switch state {
        case .aboveTop:
            guard previousState == .aboveTop else {
                let deltaInNormal = topPoint - previousOffset
                let deltaAboveTop = offset - topPoint
                adjustHeight(&heightShown, forDelta: deltaInNormal, inRangeOfState: .normal)
                adjustHeight(&heightShown, forDelta: deltaAboveTop, inRangeOfState: .aboveTop)
                return
            }

            let delta = offset - previousOffset
            adjustHeight(&heightShown, forDelta: delta, inRangeOfState: .aboveTop)

        case .normal:
            let delta = offset - previousOffset
            adjustHeight(&heightShown, forDelta: delta, inRangeOfState: .normal)

        case .belowBottom:
            guard previousState == .aboveTop else {
                let deltaInNormal = bottomPoint - previousOffset
                let deltaBelowBottom = offset - bottomPoint
                adjustHeight(&heightShown, forDelta: deltaInNormal, inRangeOfState: .normal)
                adjustHeight(&heightShown, forDelta: deltaBelowBottom, inRangeOfState: .belowBottom)
                return
            }

            let delta = offset - previousOffset
            adjustHeight(&heightShown, forDelta: delta, inRangeOfState: .belowBottom)
        }

        previousOffset = offset
        previousState = state
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // scrolling stopped
    }

}
