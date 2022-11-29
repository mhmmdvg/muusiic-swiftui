//
//  RecentlyPlayed.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 28/11/22.
//

import Foundation

struct RecentlyPlayedModel: Codable {
    let items: [RecentlyPlayedItems]
}

struct RecentlyPlayedItems: Hashable, Codable {
    let track: RecentlyPlayedTrack
}

struct RecentlyPlayedTrack: Hashable, Codable {
    let album: RecentlyPlayedAlbum
    let artists: [RecentlyPlayedArtist]
    let name: String
}

struct RecentlyPlayedAlbum: Hashable, Codable {
    let images: [RecentlyPlayedAlbumImages]
    let name: String
    
}

struct RecentlyPlayedAlbumImages: Hashable, Codable {
    let url: URL
}

struct RecentlyPlayedArtist: Hashable, Codable {
    let name: String
    
}
