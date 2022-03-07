//
//  NewsView.swift
//  NewsApp
//
//  Created by Shiddiq Syuhada on 07/03/22.
//

import SwiftUI

struct NewsView: View {
    let category: String
    @ObservedObject var news = News()
    
    var body: some View {
        List(news) {(article: NewsListItem) in
            NewsListView(article: article)
                .onAppear{
                    self.news.loadMore(currentItem: article)
                }
        }
        .navigationTitle(category)
    }
}

struct NewsListView: View {
    var article: NewsListItem
    
    var body: some View {
        Link(destination: URL(string: article.url)!, label: {
            VStack(alignment: .leading) {
                Text("\(article.title)")
                    .font(.headline)
                Text("\(article.author)")
                    .font(.subheadline)
            }
            .foregroundColor(.black)
        })
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView(category: "Business")
    }
}
