//
//  CurrentPlaylist.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 21/11/22.
//

import Foundation

class CurrentPlaylistFetcher: ObservableObject {
    
    @Published var currentPlaylist: [PlaylistUserItems] = []
    
    init() {
        fetchCurrentPlaylist()
    }
    
    private func fetchCurrentPlaylist() {
        APICaller.shared.getPlaylistUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.currentPlaylist = model.items
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
