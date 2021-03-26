//
//  NasaEntry.swift
//  NasaSearch
//
//  Created by Lynk on 3/25/21.
//

import Foundation

struct EntryWrapper: Codable {
    let collection: ResultDetails
}

struct ResultDetails: Codable {
    let items: [NasaEntry]
    let links: [PageDetails]?
}

struct PageDetails: Codable {
    let prompt: String
    let href: String
}

struct NasaEntry: Codable {
    let data: [DataDetails]
    let href: String
    let links: [ThumbnailDetails]
}

struct ThumbnailDetails: Codable {
    let href: String
}


struct DataDetails: Codable {
    let title: String
    let description: String?
    let photographer: String?
    let description_508: String?
    let location: String?
    
    var descriptionAvailable: String? {
        if let description = description {
            return description
        } else if let description = description_508 {
            return description
        }
        return "No Description Available"
    }
    
    var subDetails: String {
        switch (location,photographer) {
        case let(.some(location),.some(photographer)):
            let fullLocation = location.count > 1 ? location : "No Location"
            let fullPhotographer = photographer.count > 1 ? photographer : "No Photographer"
            return "\(fullLocation) · \(fullPhotographer)"
        case (let .some(location),.none):
            let fullLocation = location.count > 1 ? location : "No Location"
            return "\(fullLocation) · No Photographer"
        case (.none,let .some(photographer)):
            let fullPhotographer = photographer.count > 1 ? photographer : "No Photographer"
            return "No Location · \(fullPhotographer)"
        case (.none,.none):
            return "No Location · No Photographer"
        }
    }
    
}
