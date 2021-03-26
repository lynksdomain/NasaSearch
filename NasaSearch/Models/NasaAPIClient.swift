//
//  NasaAPIClient.swift
//  NasaSearch
//
//  Created by Lynk on 3/25/21.
//

import Foundation

class NasaAPIClient {
    
    private var decoder = DataDecoder<EntryWrapper>()
    private var nextPage: String?
    var isFetching = false
    
     func fetchData(searchQuery:String?,_ completion: @escaping (Result<[NasaEntry], Error>) -> ()) {
        
        var possibleURL: URL?
        
        if let searchQuery = searchQuery {
        
        var urlComp = URLComponents(string:"https://images-api.nasa.gov/search")
        let queryItems = [URLQueryItem(name: "q", value: searchQuery), URLQueryItem(name: "media_type", value: "image")]
        urlComp?.queryItems = queryItems
        possibleURL = urlComp?.url
        
        } else {
            guard let nextPage = nextPage else {
                completion(.failure(AppError.invalidUrl))
                return
            }
            possibleURL = URL(string: nextPage)
        }
        
        guard let url = possibleURL else {
            completion(.failure(AppError.invalidUrl))
            return
        }
        
        
        
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.cachePolicy = .useProtocolCachePolicy
        
        
        
        if let cacheResponse = session.configuration.urlCache?.cachedResponse(for: request) {
            switch decoder.decode(data: cacheResponse.data) {
            case let .failure(error):
                print(error)
            case let .success(entryWrapper):
                isFetching = false
                setNextPage(result: entryWrapper.collection)
                completion(.success(entryWrapper.collection.items))
            }
        } else {
            
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                } else if let data = data {
                    switch self.decoder.decode(data: data) {
                    case let .failure(error):
                        print(error)
                    case let .success(entryWrapper):
                        self.isFetching = false
                        self.setNextPage(result: entryWrapper.collection)
                        completion(.success(entryWrapper.collection.items))
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    
    private func setNextPage(result: ResultDetails) {
        guard let links = result.links else { return }
        var nextFound = false
        for link in links {
            guard link.prompt == "Next" else { continue }
            nextPage = link.href
            nextFound = true
        }
        if !nextFound {
            nextPage = nil
        }
    }
}
