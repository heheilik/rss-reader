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
        feedSourcesView: UIView,
        entriesView: UIView
    ) -> [NSLayoutConstraint] {
        [
            feedSourcesView.topAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.topAnchor
            ),
            feedSourcesView.topAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.topAnchor
            ),
            feedSourcesView.leadingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.leadingAnchor
            ),
            feedSourcesView.trailingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.trailingAnchor
            ),
            entriesView.topAnchor.constraint(
                equalTo: contentView.topAnchor
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
            feedSourcesView.heightAnchor.constraint(equalToConstant: 64)
        ]
    }

    // MARK: - Scrolling

    enum Direction {
        case none
        case upwards
        case downwards

        init(delta: Double) {
            switch delta.sign {
            case .plus:
                self = .upwards
            case .minus:
                self = .downwards
            }
        }
    }

    var feedSourcesHidden = false
    var lastContentOffset: Double = 0

    var transitionInProgress = false

    @FeedSourcesHeight var heightShown: Double

    @propertyWrapper
    struct FeedSourcesHeight {
        private var height: Double = 64
        var wrappedValue: Double {
            get {
                return max(0, min(64, height))
            }
            set {
                height = max(-1, min(65, newValue))
            }
        }
    }

}

extension FeedViewModel: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let delta = lastContentOffset - scrollView.contentOffset.y

        if !transitionInProgress {
            switch Direction(delta: delta) {
            case .upwards:
                if feedSourcesHidden {
                    transitionInProgress = true
                }

            case .downwards:
                if !feedSourcesHidden {
                    transitionInProgress = true
                }

            case .none:
                break
            }

            if !transitionInProgress {
                lastContentOffset = scrollView.contentOffset.y
                return
            }
        }

        heightShown += delta
        lastContentOffset = scrollView.contentOffset.y

        print(heightShown)

        if heightShown == 0 {
            transitionInProgress = false
            feedSourcesHidden = true
            return
        }
        if heightShown == 64 {
            transitionInProgress = false
            feedSourcesHidden = false
            return
        }

    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // scrolling stopped
    }

}
