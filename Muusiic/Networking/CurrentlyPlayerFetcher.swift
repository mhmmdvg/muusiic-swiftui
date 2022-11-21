//
//  CurrentlyPlayerFetcher.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 21/11/22.
//

import Foundation

class CurrentlyPlayerFetcher: ObservableObject {
    static let shared = CurrentlyPlayerFetcher()
    
    @Published var currentlyPlayer: CurrentlyPlayer? = nil
    
    init() {
        fetchCurrentlyPlayer()
    }
    
    public func fetchCurrentlyPlayer() {
        APICaller.shared.getCurrentlyPlayer { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.currentlyPlayer = model
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
