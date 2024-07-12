//
//  SearchResponse.swift
//  WallpaperApp
//
//  Created by school06 on 2024/06/06.
//

import Foundation

struct UnsplashPhoto: Codable {
    let id: String
    let updatedAt: String
    let ja: String?
    let altDescription: String?
    let urls: UnsplashPhotoURLs
    let user: UnsplashUser
    let alternativeSlug: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case altDescription = "alt_description"
        case ja
        case updatedAt = "updated_at"
        case urls
        case user
        case alternativeSlug = "alternative_slugs"
    }
}

struct UnsplashUser: Codable {
    let username: String
    let name: String
    let location: String?
}

struct UnsplashPhotoURLs: Codable {
    let regular: String
    let full: String
}
