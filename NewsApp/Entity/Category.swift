//
//  CategoryModel.swift
//  NewsApp
//
//  Created by Shiddiq Syuhada on 07/03/22.
//

import Foundation

struct CategoryModel: Identifiable {
    let id = UUID()
    let title: String
    
    init(title: String) {
        self.title = title
    }
}

class SelectedCategory: ObservableObject {
//    @Published var selectedCategory = ""
//
//    func updateSelected(category: String){
//        self.selectedCategory = category
//        print("\(self.selectedCategory)")
//    }
//    func getSelected() -> String {
//        return String(self.selectedCategory)
//    }
    @Published var searchTerm = ""
    @Published var country = "id"
    @Published var category = "entertainment"
    @Published var apiKey = "f60993a2b23b438a8642899a63347527"
}
