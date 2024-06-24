//
//  SearchResponse.swift
//  WallpaperApp
//
//  Created by school06 on 2024/06/06.
//

import Foundation

struct UnsplashPhoto: Decodable {
    let id: String
    let updatedAt: String
    let urls: UnsplashPhotoURLs
    let user: UnsplashUser
    
    enum CodingKeys: String, CodingKey {
        case id
        case updatedAt = "updated_at"
        case urls
        case user
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
