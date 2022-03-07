//
//  CategoriesView.swift
//  NewsApp
//
//  Created by Shiddiq Syuhada on 07/03/22.
//

import SwiftUI

struct CategoriesView: View {
    private let category: [CategoryModel] =  [
    CategoryModel(title: "Business"),
    CategoryModel(title: "Entertainment"),
    CategoryModel(title: "General"),
    CategoryModel(title: "Health"),
    CategoryModel(title: "Science"),
    CategoryModel(title: "Sport"),
    CategoryModel(title: "Technology ")]
    @ObservedObject var cats = SelectedCategory()
    
    var body: some View {
        NavigationView {
            List(category) {category in
                NavigationLink(destination: NewsView(category:category.title).onAppear{
//                    cats.updateSelected(category: category.title)
                    cats.category = category.title
                }){
                    VStack{
                        Text(category.title)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Category")
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
