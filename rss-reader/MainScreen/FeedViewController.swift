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

    @IBOutlet weak var feedSourcesContainer: UIView!
    @IBOutlet weak var entriesContainer: UIView!
    @IBOutlet weak var aboveSafeAreaCoverView: UIView!

    @IBOutlet weak var feedSourcesHeightShown: NSLayoutConstraint!

    override func viewDidLoad() {
        addChild(feedSourcesViewController)
        feedSourcesViewController.view.frame = feedSourcesContainer.bounds
        feedSourcesContainer.addSubview(feedSourcesViewController.view)
        feedSourcesViewController.didMove(toParent: self)

        addChild(entriesViewController)
        entriesViewController.view.frame = entriesContainer.bounds
        entriesContainer.addSubview(entriesViewController.view)
        entriesViewController.didMove(toParent: self)

        feedSourcesViewController.urlListDelegate = entriesViewController
        entriesViewController.scrollViewDelegate = self
    }

}

extension FeedViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.scrollViewDidScroll(scrollView)
        feedSourcesHeightShown.constant = viewModel.heightShown
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.scrollViewDidEndDecelerating(scrollView)
    }

}
