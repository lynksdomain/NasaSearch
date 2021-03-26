//
//  CollectionLayoutGuide.swift
//  NasaSearch
//
//  Created by Lynk on 3/25/21.
//

import UIKit

struct CollectionLayoutGuide {
    
    private let inset: CGFloat = 8
    private let minLineSpacing: CGFloat = 8
    private let minInteritemSpacing: CGFloat = 8
    private let columns = 3
    
    func getEdgeInsets() -> UIEdgeInsets {
            return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func getMinLineSpacing() -> CGFloat {
        return minLineSpacing
    }
    
    func getMinInteritemSpacing() -> CGFloat {
        return minInteritemSpacing
    }
    
    func getInset() -> CGFloat{
        return inset
    }
    
    func numberOfColumns() -> Int {
        return columns
    }
    
}
