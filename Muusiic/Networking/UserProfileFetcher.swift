//
//  UserProfileFetcher.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 26/11/22.
//

import Foundation

class UserProfileFetcher: ObservableObject {
    
    @Published var userProfileFetch: UserProfile? = nil
    
    init() {
        fetchUserProfile()
    }
    
    private func fetchUserProfile() {
        APICaller.shared.getUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.userProfileFetch = user
                    
                case .failure(let error):
                    print("tes 2 \(error.localizedDescription)")
                }
            }
        }
    }
    
}
