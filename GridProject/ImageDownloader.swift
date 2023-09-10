//
//  ImageDownloader.swift
//  GridProject
//
//  Created by macbook on 1/9/23.
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

class ImageDownloader: ObservableObject {
    static let shared = ImageDownloader()
    var imageURLs: [URL] = []
    //var mutableImages: MutableProperty<[UIImage]> = MutableProperty([])
    @Published var imagesInfo: [ImageInfo] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    private init() {
        fetchImage()
    }
    
    func fetchImagesURLs(completion: @escaping(Bool) -> Void) {
        guard let apiUrl = URL(string: "https://api.unsplash.com/photos/?client_id=Rj4XreSyVEVD7TLBXA1oCTCHETlncgw4GpAwFCWUo0s&order_by=ORDER&per_page=30") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("Bearer lgkyjtMJUDC18PPcrwYHZkTf7D1LKpp3QE6JVcKOABcwz2I7bB0hAbSD", forHTTPHeaderField: "Authorization")
        
        print("request: \(request)")
        
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
                let picInfo = try decoder.decode([DownloadImageInfo].self, from: data)
                self.imageURLs = picInfo.map { $0.urls.regularURL }
                // print(self.ImageURLs)
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
                    //                    let producer = SignalProducer<Data, NSError> { observer, disposable in
                    //                        URLSession.shared.dataTask(with: imageURL) { data, _, error in
                    //                            if let error = error as? NSError {
                    //                                observer.send(error: error)
                    //                            } else if let data {
                    //                                print("data success")
                    //                                observer.send(value: data)
                    //                                observer.sendCompleted()
                    //                            }
                    //                        }.resume()
                    //                    }
                    //
                    //                    producer
                    //                        .map { UIImage(data: $0)}
                    //                        .skipNil()
                    //                        .startWithResult { [weak self] downloadResponse in
                    //                            switch downloadResponse {
                    //                            case .success(let downloadImage): self?.images.append(downloadImage)
                    //                            case .failure(let error): print("[ImageDownloader] failed to get image: \(error)")
                    //                            }
                    //                        }
                    //                        .dispose()
                    URLSession.shared.dataTaskPublisher(for: imageURL)
                        .map(\.data)
                        .compactMap { UIImage(data: $0) }
                        .replaceError(with: nil)
                        .receive(on: DispatchQueue.main)
                        .sink { [weak self] image in
                            if let image = image {
                                let imageInfo = ImageInfo(id: index, image: image, rating: Int.random(in: 1...5))
                                self?.imagesInfo.append(imageInfo)
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
}
