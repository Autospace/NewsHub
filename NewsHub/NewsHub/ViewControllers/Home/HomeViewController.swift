//
//  HomeViewController.swift
//  NewsHub
//
//  Created by Alex Mostovnikov on 13/2/20.
//  Copyright © 2020 MALX. All rights reserved.
//

import UIKit
import SwiftSoup

class HomeViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private var rssFeeds: [(link: String, title: String)] = []
    private var cellIdentifier = "DefaultCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TUT.BY feeds"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        loadRSSFeeds()
    }

    private func loadRSSFeeds() {
        let network = Network()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        network.getRSSPageOfSite(by: URL(string: "https://news.tut.by/rss.html")!) {[weak self] (htmlDocument) in
            guard let doc = try? SwiftSoup.parse(htmlDocument), let elements = try? doc.getAllElements() else {
                return
            }
            for element in elements {
                if element.hasAttr("href"), let link = try? element.attr("href"), let url = URL(string: link) {
                    dispatchGroup.enter()
                    network.detectRssFeed(by: url) {[weak self] (isRSS) in
                        if isRSS {
                            var title = (try? element.text()) ?? ""
                            if title.isEmpty { title = url.absoluteString }
                            self?.rssFeeds.append((link: url.absoluteString, title: title))
                        }
                        dispatchGroup.leave()
                    }
                }
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.showRssFeeds()
        }
    }
    
    @IBAction private func onLoadRSS() {
        loadRSSFeeds()
    }
    
    private func showRssFeeds() {
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssFeeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell.textLabel?.text = rssFeeds[indexPath.row].title
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: implement functionality to load rss content for selected feed
        print(rssFeeds[indexPath.row].link)
    }
}
