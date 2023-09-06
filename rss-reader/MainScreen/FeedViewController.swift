//
//  FeedViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 17.06.23.
//

import UIKit

final class FeedViewController: UIViewController {

    @IBOutlet var feedSourcesCollectionViewController: FeedSourcesCollectionViewController!
    @IBOutlet var entriesTableViewController: EntriesTableViewController!

    private let viewModel = FeedViewModel()

    override func awakeFromNib() {
        print("\(Self.self) awaken from nib")
        super.awakeFromNib()

//        UINib(nibName: "FeedSourcesCollectionViewController", bundle: nil).instantiate(withOwner: feedSourcesCollectionViewController)
//        UINib(nibName: "EntriesTableViewController", bundle: nil).instantiate(withOwner: entriesTableViewController)
//        super.awakeFromNib()
//
//        addChild(feedSourcesCollectionViewController)
//        feedSourcesCollectionViewController.didMove(toParent: self)
//
//        addChild(entriesTableViewController)
//        entriesTableViewController.didMove(toParent: self)

    }

    override func viewDidLoad() {
        print("\(Self.self) did load")
    }

}
