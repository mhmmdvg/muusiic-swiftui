//
//  RecentlyPlayedFetcher.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 28/11/22.
//

import Foundation

class RecentlyPlayedFetcher: ObservableObject {
    
    @Published var recentlyPlayedFetch: [RecentlyPlayedItems] = []
    
    init() {
        fetchRecentlyPlayed()
    }
    
    private func fetchRecentlyPlayed() {
        APICaller.shared.getRecentlyPlayed { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let recent):
                    self.recentlyPlayedFetch = recent.items
                    
                case .failure(let error):
                    print("tes \(error.localizedDescription)")
                }
            }
        }
    }
    
}
