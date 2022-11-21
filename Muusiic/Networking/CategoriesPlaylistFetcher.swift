//
//  CategoriesPlaylistFetcher.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 21/11/22.
//

import Foundation

class CategoriesPlaylistFetcher: ObservableObject {
    
    @Published var categories: [CategoryItems] = []
    
    init() {
        fetchCategoriesPlaylist()
    }
    
    private func fetchCategoriesPlaylist() {
        APICaller.shared.getCategoryPlaylist { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.categories = model.categories.items
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
