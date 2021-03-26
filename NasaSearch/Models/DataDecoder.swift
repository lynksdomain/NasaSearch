//
//  DataDecoder.swift
//  NasaSearch
//
//  Created by Lynk on 3/26/21.
//

import UIKit

struct DataDecoder<T:Codable> {
     func decode(data:Data) -> Result<T,Error> {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }
}
