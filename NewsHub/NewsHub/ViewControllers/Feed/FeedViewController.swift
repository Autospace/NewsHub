//
//  FeedViewController.swift
//  NewsHub
//
//  Created by Alex Mostovnikov on 21/7/20.
//  Copyright © 2020 MALX. All rights reserved.
//

import UIKit
import FeedKit
import SafariServices

class FeedViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    var feed: Feed?
    private var cellIdentifier = "DefaultCell"
    private var rssFeedItems: [RSSFeedItem] = []
    private var jsonFeedItems: [JSONFeedItem]?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = feed?.title
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        loadRssFeed()
    }

    private func loadRssFeed() {
        guard let feedUrlString = feed?.link, let feedUrl = URL(string: feedUrlString) else {
            return
        }

        let parser = FeedParser(URL: feedUrl)
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) {[weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let feed):
                DispatchQueue.main.async {
                    switch feed {
                    case .atom:
                        assertionFailure("Need to implement functionality to work with atom feed")
                    case .rss(let rssFeed):
                        if let items = rssFeed.items {
                            self.rssFeedItems = items
                            self.tableView.reloadData()
                        }
                    case .json:
                        assertionFailure("Need to implement functionality to work with JSON feed")
                    }
                }
            case .failure(let error):
                assertionFailure("\(error.localizedDescription)")
            }
        }
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssFeedItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = rssFeedItems[indexPath.row].title
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let itemLink = rssFeedItems[indexPath.row].link, let url = URL(string: itemLink) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}
