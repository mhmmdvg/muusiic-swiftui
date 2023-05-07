//
//  SearchResult.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 06/05/23.
//

import Foundation

struct SearchResult: Codable {
    let tracks: SearchResultTracks
}

struct SearchResultTracks: Hashable, Codable {
    let items: [SearchResultItems]
}
        
struct SearchResultItems: Hashable,Codable {
    let album: SearchResultAlbums
    let artists: [SearchResultArtists]
    let name: String
}

struct SearchResultAlbums: Hashable, Codable {
    let images: [SearchResultAlbumImages]
    let name: String
}

struct SearchResultAlbumImages: Hashable, Codable {
    let url: URL?
}

struct SearchResultArtists: Hashable, Codable {
    let name: String
}
