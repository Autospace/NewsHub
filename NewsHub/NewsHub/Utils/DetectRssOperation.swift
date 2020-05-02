//
//  DetectRssOperation.swift
//  NewsHub
//
//  Created by Alex Mostovnikov on 2/5/20.
//  Copyright © 2020 MALX. All rights reserved.
//

import Foundation

class DetectRssOperation: AsyncOperation {
    let url: URL
    let rssService: RssService
    var isRSS: Bool?
    
    init(url: URL, rssService: RssService) {
        self.url = url
        self.rssService = rssService
    }
    
    override func main() {
        rssService.detectRssFeed(by: url) {[unowned self] (isRSS) in
            self.isRSS = isRSS
            self.state = .finished
        }
    }
}
