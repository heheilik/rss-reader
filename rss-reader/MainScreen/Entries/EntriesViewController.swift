//
//  EntriesViewController.swift
//  rss-reader
//
//  Created by Heorhi Heilik on 5.09.23.
//

import UIKit

class EntriesViewController: UIViewController {

    let viewModel = EntriesViewModel()

    @IBOutlet weak var tableView: UITableView!

    override func awakeFromNib() {
        print("\(Self.self) awaken from nib")
        UINib(nibName: "\(Self.self)", bundle: nil).instantiate(withOwner: self)
        super.awakeFromNib()
        print("\(Self.self) super awaken from nib")
    }

    override func viewDidLoad() {

        print("\(Self.self) did load")

        tableView.register(
            nib: UINib(nibName: "FeedEntryTableViewCell", bundle: nil),
            for: FeedEntryInfoTableViewCell.self
        )
        tableView.register(
            nib: UINib(nibName: "StatusTableViewCell", bundle: nil),
            for: StatusTableViewCell.self
        )
    }

}

extension EntriesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sectionCount()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let typedSection = viewModel.section(forIndex: section)
        switch typedSection {
        case .status:
            return 1
        case .entries:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let typedSection = viewModel.section(forIndexPath: indexPath)
        switch typedSection {
        case .status:
            print("called dequeueing")
            return tableView.dequeue(StatusTableViewCell.self, for: indexPath) { cell in
                cell.setStatus(.start)
            }
        case .entries:
            fatalError("Entry cell configuration is not set.")
        }
    }
    
}

extension EntriesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let typedSection = viewModel.section(forIndexPath: indexPath)
        switch typedSection {
        case .status:
            return 500
        case .entries:
            return UITableView.automaticDimension
        }
    }

}
