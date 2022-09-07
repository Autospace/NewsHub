//
//  Network.swift
//  NewsHub
//
//  Created by Alex Mostovnikov on 25/2/20.
//  Copyright © 2020 MALX. All rights reserved.
//

import Foundation

class RssService: NSObject {
    let session: URLSession
    
    init(urlSession: URLSession = URLSession(configuration: .ephemeral)) {
        session = urlSession
    }
    
    func getRSSPageOfSite(by url: URL, completion: @escaping (_ htmlDocument: String) -> Void) {
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion("")
                return
            }
            
            if let data = data, let stringData = String(data: data, encoding: .utf8) {
                completion(stringData)
                return
            }
            completion("")
        }
        dataTask.resume()
    }
    
    func detectRssFeed(by url: URL, completion: @escaping (_ isRSS: Bool) -> Void) {
        // FIXME: need to update this method to use URLSession class' property instead of local in the method
        let session = URLSession(configuration: .ephemeral)
        var request = URLRequest(url: url)
        request.httpMethod = "Head"
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let contentType = httpResponse.allHeaderFields["Content-Type"] as? String else {
                completion(false)
                return
            }
            if contentType.hasPrefix("application/rss+xml") || contentType.hasPrefix("application/xml") {
                completion(true)
            } else {
                completion(false)
            }
        }
        dataTask.resume()
    }
}
