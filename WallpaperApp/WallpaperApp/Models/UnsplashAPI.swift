//
//  File.swift
//  WallpaperApp
//
//  Created by school06 on 2024/06/02.
//

import Foundation

class UnsplashAPI {
    
    private let accessKey = "hZ6EuwcBL2h8ybpYbcLTWVtleTTDznHszzlMP0e5dwQ"
    
    // 新着画像を取得する
    func fetchLatestWallpapers(numberOfPages: Int, completion: @escaping ([UnsplashPhoto]?) -> Void) {
        let urlString = "https://api.unsplash.com/photos?order_by=latest&per_page=\(numberOfPages)&client_id=\(accessKey)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching latest wallpapers:", error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([UnsplashPhoto].self, from: data)
                completion(photos)
            } catch {
                print("Error decoding latest wallpapers:", error)
                completion(nil)
            }
        }.resume()
    }
    
    // 色指定で画像を取得する
    func searchWallpapersByColor(numberOfPages: Int, colorTag: ColorTag, completion: @escaping ([UnsplashPhoto]?) -> Void) {
        let urlString = "https://api.unsplash.com/search/photos?query=\(colorTag.rawValue)&per_page=\(numberOfPages)&color=\(colorTag.rawValue)&client_id=\(accessKey)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            do {
                let response = try JSONDecoder().decode(SearchResponse.self, from: data)
                completion(response.results)
            } catch {
                print("Error decoding search wallpapers:", error)
                completion(nil)
            }
            if let error = error {
                print("Error search wallpapers:", error)
                completion(nil)
                return
            }
        }.resume()
    }
}

// SearchのAPIは画像を取得する際の階層がfetchと異なる
struct SearchResponse: Decodable {
    let results: [UnsplashPhoto]
}
