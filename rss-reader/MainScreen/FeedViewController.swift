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

    private let aboveSafeAreaCover = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        view.translatesAutoresizingMaskIntoConstraints = false
        feedSourcesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        entriesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        aboveSafeAreaCover.translatesAutoresizingMaskIntoConstraints = false

        addChild(feedSourcesViewController)
        addChild(entriesViewController)

        view.addSubview(entriesViewController.view)
        view.addSubview(feedSourcesViewController.view)
        view.addSubview(aboveSafeAreaCover)

        entriesViewController.didMove(toParent: self)
        feedSourcesViewController.didMove(toParent: self)

        NSLayoutConstraint.activate(
            viewModel.constraintsFor(
                contentView: view,
                entriesView: entriesViewController.view,
                feedSourcesView: feedSourcesViewController.view,
                aboveSafeAreaCoverView: aboveSafeAreaCover
            )
        )
    }

    override func viewDidLoad() {
        entriesViewController.scrollViewDelegate = self
    }

}

extension FeedViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.scrollViewDidScroll(scrollView)
        guard let constraint = view.constraints.filter({ constraint in
            guard
                let first = constraint.firstItem as? UIView,
                let second = constraint.secondItem as? UIView,
                let feedSourcesView = feedSourcesViewController.view as? UIView,
                let aboveSafeAreaCover = aboveSafeAreaCover as? UIView
            else {
                return false
            }

            return
            first == feedSourcesView &&
            second == aboveSafeAreaCover &&
            constraint.firstAttribute == .bottom &&
            constraint.secondAttribute == .bottom


        }).first else {
            fatalError("Constraint not found.")
        }

        constraint.constant = viewModel.heightShown
        print(constraint.constant)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.scrollViewDidEndDecelerating(scrollView)
    }

}
