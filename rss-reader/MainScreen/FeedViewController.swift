//
//  FeedViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 17.06.23.
//

import UIKit

final class FeedViewController: UIViewController {

    private let viewModel = FeedViewModel()

    private let feedSourcesViewController = FeedSourcesViewController()
    private let entriesViewController = EntriesViewController()

    private var isFeedSourcesHidden = false
    private var isScrollingUp = false
    private var lastContentOffset = CGPoint()

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        view.translatesAutoresizingMaskIntoConstraints = false
        feedSourcesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        entriesViewController.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(feedSourcesViewController)
        addChild(entriesViewController)

        view.addSubview(entriesViewController.view)
        view.addSubview(feedSourcesViewController.view)

        NSLayoutConstraint.activate(
            viewModel.constraintsFor(
                contentView: view,
                feedSourcesView: feedSourcesViewController.view,
                entriesView: entriesViewController.view
            )
        )

        feedSourcesViewController.didMove(toParent: self)
        entriesViewController.didMove(toParent: self)
    }

    override func viewDidLoad() {
        entriesViewController.scrollViewDelegate = self
    }

}

extension FeedViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.scrollViewDidScroll(scrollView)

        guard let constraint = feedSourcesViewController.view.constraints.filter({ constraint in
            constraint.firstAttribute == .top && constraint.secondAttribute == .top
        }).first else {
            fatalError("Constraint is deleted.")
        }

        constraint.constant = viewModel.heightShown - 64
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.scrollViewDidEndDecelerating(scrollView)
    }

}
