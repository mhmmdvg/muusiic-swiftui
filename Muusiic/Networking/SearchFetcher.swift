//
//  SearchFetcher.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 30/04/23.
//

import Foundation

class SearchFetcher: ObservableObject {
    
    @Published var searchingFetch: [CurrentlyPlayer] = []
    var searchKey: String = ""
    
    
    init() {
        fetchSearching(searchKey: searchKey)
    }
    
    private func fetchSearching(searchKey: String) {
        APICaller.shared.getSearch(key: searchKey) { success in
            DispatchQueue.main.async {
                switch success {
                case .success(let result):
                    print(result)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
