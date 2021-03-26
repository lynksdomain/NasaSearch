//
//  ImageClient.swift
//  NasaSearch
//
//  Created by Lynk on 3/25/21.
//

import UIKit

enum AppError: Error {
    case invalidUrl, noImages
}

struct ImageClient {
    
    private static var cache = NSCache<NSString, UIImage>()
    
    public func fetchImage(urlString: String, completion: @escaping (Result<UIImage,Error>) -> Void) {
        
        if let image = fetchImageFromCache(urlString: urlString) {
            completion(.success(image))
            return
        }
       
        guard let formattedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: formattedString) else {
            completion(.failure(AppError.invalidUrl))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                guard let image = UIImage(data: data) else {
                    return
                }
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func fetchImageFromCache(urlString: String) -> UIImage? {
        return ImageClient.cache.object(forKey: urlString as NSString)
    }
    
     func getOriginalSize(urlString:String,completion: @escaping (Result<UIImage,Error>) -> Void) {
        guard let formattedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: formattedString) else {
            completion(.failure(AppError.invalidUrl))
            return
        }
        
        let decoder = DataDecoder<[String]>()
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.cachePolicy = .useProtocolCachePolicy
        
        if let cacheResponse = session.configuration.urlCache?.cachedResponse(for: request) {
            switch decoder.decode(data: cacheResponse.data) {
            case let .failure(error):
                completion(.failure(error))
            case let .success(links):
                guard links.count > 0 else {
                    completion(.failure(AppError.noImages))
                    return
                }
                fetchImage(urlString: links[0]) { (result) in
                    switch result {
                    case let .failure(error):
                        completion(.failure(error))
                    case let .success(image):
                        completion(.success(image))
                    }
                }
            }
        } else {
            
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    switch decoder.decode(data: data) {
                    case let .failure(error):
                        completion(.failure(error))
                    case let .success(links):
                        
                        fetchImage(urlString: links[0]) { (result) in
                            switch result {
                            case let .failure(error):
                                completion(.failure(error))
                            case let .success(image):
                                completion(.success(image))
                            }
                        }
                    }

                }
            }
            dataTask.resume()
        }
    }
    
}

