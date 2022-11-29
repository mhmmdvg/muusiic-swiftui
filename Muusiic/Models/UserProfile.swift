//
//  UserProfile.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 22/11/22.
//

import Foundation

struct UserProfile: Codable {
    let display_name: String
    let id: String
    let images: [ImagesProfile]
}

struct ImagesProfile: Codable {
    let url: URL
}
