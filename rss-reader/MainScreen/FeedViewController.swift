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

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        feedSourcesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        entriesViewController.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(feedSourcesViewController)
        addChild(entriesViewController)

        view.addSubview(feedSourcesViewController.view)
        view.addSubview(entriesViewController.view)

        NSLayoutConstraint.activate(
            viewModel.constraintsFor(
                contentView: self.view,
                feedSourcesView: feedSourcesViewController.view,
                entriesView: entriesViewController.view
            )
        )

//        NSLayoutConstraint.activate([
//            feedSourcesViewController.view.topAnchor.constraint(
//                equalTo: self.view.safeAreaLayoutGuide.topAnchor
//            ),
//            feedSourcesViewController.view.leadingAnchor.constraint(
//                equalTo: self.view.safeAreaLayoutGuide.leadingAnchor
//            ),
//            feedSourcesViewController.view.trailingAnchor.constraint(
//                equalTo: self.view.safeAreaLayoutGuide.trailingAnchor
//            ),
//            entriesViewController.view.bottomAnchor.constraint(
//                equalTo: self.view.bottomAnchor
//            ),
//            entriesViewController.view.leadingAnchor.constraint(
//                equalTo: self.view.safeAreaLayoutGuide.leadingAnchor
//            ),
//            entriesViewController.view.trailingAnchor.constraint(
//                equalTo: self.view.safeAreaLayoutGuide.trailingAnchor
//            ),
//            feedSourcesViewController.view.bottomAnchor.constraint(
//                equalTo: entriesViewController.view.topAnchor,
//                constant: 8
//            )
//        ])

        feedSourcesViewController.didMove(toParent: self)
        entriesViewController.didMove(toParent: self)
    }

    override func viewDidLoad() {
        print("\(Self.self) did load")
    }

}
