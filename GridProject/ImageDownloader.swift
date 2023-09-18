//
//  ImageDownloader.swift
//  GridProject
//
//  Created by Rakib on 1/9/23.
//

import Combine
import Foundation
import ReactiveSwift
import SwiftUI

struct DownloadImageInfo: Codable {
    let urls: Urls
}

struct Urls: Codable {
    var regular: String
    var regularURL: URL {
        return URL(string: regular)!
    }
}

struct ImageInfo: Hashable {
    var id: Int
    var image: UIImage
    var rating: Int
}

struct UnsplashResponse: Codable {
    let results: [UnsplashImage]
}

struct UnsplashImage: Codable, Identifiable {
    let id: String
    let description: String?
    let urls: UnsplashImageUrls
}

struct UnsplashImageUrls: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    var regularURL: URL {
        return URL(string: regular)!
    }
}

class ImageDownloader: ObservableObject {
    static let shared = ImageDownloader()
    var imageURLs: [URL] = []
    //var mutableImages: MutableProperty<[UIImage]> = MutableProperty([])
    @Published var imagesInfo: [ImageInfo] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let accessKey = "Rj4XreSyVEVD7TLBXA1oCTCHETlncgw4GpAwFCWUo0s"
    let searchText = "flower"
    let currentPage = 1
    let imagesPerPage = 30
    
    private init() {
        setInitialImageInfo()
        fetchImage()
    }
    
    //"https://api.unsplash.com/photos/?client_id=\(api)&order_by=ORDER&per_page=30")
    
    func fetchImagesURLs(completion: @escaping(Bool) -> Void) {
        let searchQuery = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.unsplash.com/search/photos?client_id=\(accessKey)&query=\(searchQuery)&page=\(currentPage)&per_page=\(imagesPerPage)"
        guard let apiUrl = URL(string: urlString) else {
            completion(false)
            return
        }
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: apiUrl) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                print("No data received")
                completion(false)
                return
            }
            print("data: \(data)")
            print("status: \(response.statusCode)")
            
            do {
                let decoder = JSONDecoder()
                let picInfo = try decoder.decode(UnsplashResponse.self, from: data)
                let results = picInfo.results
                self.imageURLs = results.map { $0.urls.regularURL }
                completion(true)
                
            } catch {
                print("decode failed")
                completion(false)
            }
        }
        
        task.resume()
    }
    
    func fetchImage() {
        fetchImagesURLs() { result in
            if result {
                //print("count: \(self.ImageURLs)")
                self.imageURLs.enumerated().forEach() { (index, imageURL) in
                    
                    URLSession.shared.dataTaskPublisher(for: imageURL)
                        .map(\.data)
                        .compactMap { UIImage(data: $0) }
                        .replaceError(with: nil)
                        .receive(on: DispatchQueue.main)
                        .sink { [weak self] image in
                            if let image = image {
                                self?.imagesInfo[index].image = image
                            }
                        }
                        .store(in: &self.cancellables)
                }
            }
        }
    }
    
    func sortImagesByRating() {
        imagesInfo.sort { $0.rating > $1.rating }
    }
    
    func getRating(with id: Int) -> Int {
        let imageInfo = imagesInfo.first(where: { $0.id == id })
        return imageInfo?.rating ?? 1
    }
    
    func updateRaing(with id: Int, newRating: Int) {
        if let index = imagesInfo.firstIndex(where: { $0.id == id} ) {
            imagesInfo[index].rating = newRating
        }
    }
    
    func setInitialImageInfo() {
        for index in 0...30 {
            let imageInfo = ImageInfo(id: index, image: UIImage(), rating: Int.random(in: 1...5))
            imagesInfo.append(imageInfo)
        }
    }
}
