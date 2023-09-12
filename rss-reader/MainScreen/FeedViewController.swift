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
        feedSourcesContainer.translatesAutoresizingMaskIntoConstraints = false
        feedSourcesContainer.addSubview(feedSourcesViewController.view)

        NSLayoutConstraint.activate([
            feedSourcesContainer.topAnchor.constraint(equalTo: feedSourcesViewController.view.topAnchor),
            feedSourcesContainer.bottomAnchor.constraint(equalTo: feedSourcesViewController.view.bottomAnchor),
            feedSourcesContainer.leadingAnchor.constraint(equalTo: feedSourcesViewController.view.leadingAnchor),
            feedSourcesContainer.trailingAnchor.constraint(equalTo: feedSourcesViewController.view.trailingAnchor),
        ])

        feedSourcesViewController.didMove(toParent: self)

        addChild(entriesViewController)
        entriesContainer.translatesAutoresizingMaskIntoConstraints = false
        entriesContainer.addSubview(entriesViewController.view)

        NSLayoutConstraint.activate([
            entriesContainer.topAnchor.constraint(equalTo: entriesViewController.view.topAnchor),
            entriesContainer.bottomAnchor.constraint(equalTo: entriesViewController.view.bottomAnchor),
            entriesContainer.leadingAnchor.constraint(equalTo: entriesViewController.view.leadingAnchor),
            entriesContainer.trailingAnchor.constraint(equalTo: entriesViewController.view.trailingAnchor),
        ])

        entriesViewController.didMove(toParent: self)

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
