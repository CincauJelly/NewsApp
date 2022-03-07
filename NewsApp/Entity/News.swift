//
//  NewsModel.swift
//  NewsApp
//
//  Created by Shiddiq Syuhada on 07/03/22.
//

import Foundation
import SwiftUI

class News: ObservableObject, RandomAccessCollection {
    typealias Element = NewsListItem
    
    @Published var newsListItem = [NewsListItem]()
    
    var startIndex: Int {newsListItem.startIndex}
    var endIndex: Int {newsListItem.endIndex}
    var nextPageToLoad = 1
    var currentlyLoading = false
    var doneLoading = false
    var searchTerm = ""
    var country = "id"
    var category = "entertainment"
    var apiKey = "f60993a2b23b438a8642899a63347527"
    
    var urlRequest = "https://newsapi.org/v2/top-headlines?"
//    country=id&category=entertainment&apiKey=f60993a2b23b438a8642899a63347527&page=
    init() {
        loadMore()
    }
    
    subscript(position: Int) -> NewsListItem {
        return newsListItem[position]
    }
    
    func loadMore(currentItem: NewsListItem? = nil) {
        if !shouldLoadMoreData(currentItem: currentItem) {
            return
        }
        currentlyLoading = true
        let urlString = "\(urlRequest)\(searchTerm)country=\(country)&category=\(category)&apiKey=\(apiKey)&page=\(nextPageToLoad)"
        print(urlString)
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: parseArticleFromResponse(data:response:error:))
        task.resume()
    }
    
    func shouldLoadMoreData(currentItem: NewsListItem? = nil) -> Bool {
        if currentlyLoading || doneLoading {
            return false
        }
        
        guard let currentItem = currentItem else {
            return true
        }
        guard let lastItem = newsListItem.last else {
            return true
        }
        for n in (newsListItem.count - 4)...(newsListItem.count - 1) {
            if n >= 0 && currentItem.uuid == newsListItem[n].uuid{
                return true
            }
        }
        return currentItem.uuid == lastItem.uuid
    }
    
    func parseArticleFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            currentlyLoading = false
            return
        }
        guard let data = data else {
            print("No data found")
            currentlyLoading = false
            return
        }
        
        let newArticles = parseArticlesFromData(data: data)
        DispatchQueue.main.async {
            self.newsListItem.append(contentsOf: newArticles)
            self.nextPageToLoad += 1
            self.currentlyLoading = false
            self.doneLoading = (newArticles.count == 0)
        }
    }
    
    func parseArticlesFromData(data: Data) -> [NewsListItem] {
        let jsonObject = try! JSONSerialization.jsonObject(with: data)
        let topLevelMap = jsonObject as! [String: Any]
        guard topLevelMap["status"] as? String == "ok" else {
            print("Status returned not OK")
            return []
        }
        guard let jsonArticles = topLevelMap["articles"] as? [[String: Any]] else {
            print("No articles found")
            return []
        }
        
        var newArticles = [NewsListItem]()
        for jsonArticle in jsonArticles {
            guard let title = jsonArticle["title"] as? String else {
                continue
            }
            guard let author = jsonArticle["author"] as? String else {
                continue
            }
            guard let url = jsonArticle["url"] as? String else {
                continue
            }
            newArticles.append(NewsListItem(title: title, author: author, url: url))
        }
        return newArticles
    }
}

class NewsListItem: Identifiable {
    var uuid = UUID()
    
    var author: String
    var title: String
    var url: String
    
    init(title: String, author:String, url: String) {
        self.title = title
        self.author = author
        self.url = url
    }
}
