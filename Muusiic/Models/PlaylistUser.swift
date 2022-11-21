//
//  PlaylistUser.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 21/11/22.
//

import Foundation

struct PlaylistUser: Codable {
    let items: [PlaylistUserItems]
}

struct PlaylistUserItems: Hashable, Codable {
    let name: String
    let id: String
    let description: String
    let images: [PlaylistImages]
    let owner: Owner
}

struct PlaylistImages: Hashable, Codable {
    let url: URL
}

struct Owner: Hashable, Codable {
    let display_name: String
}
