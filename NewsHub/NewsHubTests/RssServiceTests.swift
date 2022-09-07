//
//  NewsHubTests.swift
//  NewsHubTests
//
//  Created by Alex Mostovnikov on 13/2/20.
//  Copyright © 2020 MALX. All rights reserved.
//

import XCTest
@testable import NewsHub

class RssServiceTests: XCTestCase {
    var expectation: XCTestExpectation!
    var service: RssService!
    let timeout: TimeInterval = 3

    override func setUp() {
        expectation = self.expectation(description: "Server response in a reasonable time")
        service = RssService()
    }

    func test_rssServiceGetPage() {
        let url = URL(string: "https://devby.io/rss")!
        service.getRSSPageOfSite(by: url) { (htmlDocument) in
            defer { self.expectation.fulfill() }
            XCTAssertNotEqual(htmlDocument, "")
        }

        waitForExpectations(timeout: timeout)
    }

    func test_rssServiceGetFakePage() {
        let fakeURL = URL(string: "dummy")!
        service.getRSSPageOfSite(by: fakeURL) { (emptyString) in
            defer { self.expectation.fulfill() }
            XCTAssertEqual(emptyString, "")
        }

        waitForExpectations(timeout: timeout)
    }

    func test_rssServiceGetPageWithNonHTMLData() {
        let url = URL(string: "https://image.shutterstock.com/image-photo/mountains-during-sunset-beautiful-natural-600w-407021107.jpg")!
        service.getRSSPageOfSite(by: url) { (emptyString) in
            defer { self.expectation.fulfill() }
            XCTAssertEqual(emptyString, "")
        }

        waitForExpectations(timeout: timeout)
    }

    func test_rssServiceDetectValidRss() {
        let url = URL(string: "https://devby.io/rss")!
        service.detectRssFeed(by: url) { (isRss) in
            defer { self.expectation.fulfill() }
            XCTAssertTrue(isRss)
        }
        waitForExpectations(timeout: timeout)
    }

    func test_rssServiceDetectInvalidRss() {
        let url = URL(string: "https://devby.io")!
        service.detectRssFeed(by: url) { (isRss) in
            defer { self.expectation.fulfill() }
            XCTAssertFalse(isRss)
        }
        waitForExpectations(timeout: timeout)
    }

}
