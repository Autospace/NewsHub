//
//  HomeViewController.swift
//  NewsHub
//
//  Created by Alex Mostovnikov on 13/2/20.
//  Copyright © 2020 MALX. All rights reserved.
//

import UIKit
import SwiftSoup

struct Feed {
    var title: String
    var link: String
}

class HomeViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var progressView: UIProgressView!

    private var rssFeeds: [Feed] = []
    private var cellIdentifier = "DefaultCell"
    private let screenTitle = "Devby feeds"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = screenTitle
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        configureRefreshControl()
        progressView.isHidden = true
        loadRSSFeeds()
    }

    private func loadRSSFeeds() {
        let rssService = RssService()
        progressView.isHidden = false
        progressView.progress = 0.0
        rssService.getRSSPageOfSite(by: URL(string: "https://devby.io/rss")!) {[weak self] (htmlDocument) in
            guard let doc = try? SwiftSoup.parse(htmlDocument), let elements = try? doc.getAllElements(), let self = self else {
                return
            }
            let operationQueue = OperationQueue()
            operationQueue.qualityOfService = .userInteractive
            operationQueue.maxConcurrentOperationCount = 1
            var numberOfRssFeeds = 0
            var numberOfCheckedElements = 0
            for element in elements {
                if element.hasAttr("href"), let link = try? element.attr("href"), let url = URL(string: link) {
                    let operation = DetectRssOperation(url: url, rssService: rssService)
                    operation.completionBlock = {
                        guard let isRSS = operation.isRSS else {
                            return
                        }
                        if isRSS {
                            var title = (try? element.text()) ?? ""
                            if title.isEmpty { title = url.absoluteString }
                            self.rssFeeds.append(Feed(title: title, link: url.absoluteString))
                            DispatchQueue.main.async {
                                numberOfRssFeeds += 1
                                self.title = "Scanning... (\(numberOfRssFeeds)) RSS-feeds found"
                            }
                        }
                        DispatchQueue.main.async {
                            numberOfCheckedElements = self.updateProgress(by: numberOfCheckedElements, with: elements.count)
                        }
                    }
                    operationQueue.addOperation(operation)
                } else {
                    DispatchQueue.main.async {
                        numberOfCheckedElements = self.updateProgress(by: numberOfCheckedElements, with: elements.count)
                    }
                }
            }
            operationQueue.waitUntilAllOperationsAreFinished()
            DispatchQueue.main.async {
                self.title = self.screenTitle
                self.tableView.refreshControl?.endRefreshing()
                self.showRssFeeds()
                self.progressView.isHidden = true
            }
        }
    }
    
    private func showRssFeeds() {
        tableView.reloadData()
    }

    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    private func updateProgress(by numberOfCheckedElements: Int, with totalNumberOfElements: Int) -> Int {
        let increasedNumberOfCheckedElements = numberOfCheckedElements + 1
        progressView.progress = Float(increasedNumberOfCheckedElements) / Float(totalNumberOfElements)
        return increasedNumberOfCheckedElements
    }

    @objc func handleRefreshControl() {
        loadRSSFeeds()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssFeeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = rssFeeds[indexPath.row].title
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        return UITableViewCell()
    }

}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller: FeedViewController = .instantiateFromStoryboard()
        controller.feed = rssFeeds[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
