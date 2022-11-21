//
//  Categories.swift
//  Muusiic
//
//  Created by Muhammad Vikri on 21/11/22.
//

import Foundation

struct CategoriesObj: Codable {
    var categories: Categories
}

struct Categories: Codable {
    var items: [CategoryItems]
}

struct CategoryItems: Hashable, Codable {
    var href: URL
    var icons: [Icons]
    var name: String
}

struct Icons: Hashable, Codable {
    var url: URL
}
