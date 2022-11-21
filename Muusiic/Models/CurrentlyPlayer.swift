//
//  CurrentlyPlayer.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 21/11/22.
//

import Foundation

struct CurrentlyPlayer: Codable {
    var progress_ms: Int64
    var is_playing: Bool
    var item: Item
}

struct Item: Codable {
    var album: Album

    var name: String
}

struct Album: Codable {
    var album_type: String
    var total_tracks: Int
    var available_markets: [String]
    var images: [Images]
    var artists: [Artists]
    var name: String
    
}

struct Images: Codable {
    var url: URL
}

struct Artists: Codable {
    var name: String
}
