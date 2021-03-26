//
//  SearchViewController+CollectionViewDelegates.swift
//  NasaSearch
//
//  Created by Lynk on 3/26/21.
//

import UIKit


extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchEntries.count == 0 {
            collectionView.backgroundView?.isHidden = false
        } else {
            collectionView.backgroundView?.isHidden = true
        }
        return searchEntries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as? GalleryCell else { return UICollectionViewCell() }
        let entry = searchEntries[indexPath.row]
        imageClient.fetchImage(urlString: entry.links[0].href) { (result) in
            switch result {
            case .failure(_):
                DispatchQueue.main.async {
                    cell.galleryImageView.image = nil
                }
            case let .success(image):
                DispatchQueue.main.async {
                    cell.galleryImageView.image = image
                }
            }
        }
        return cell
    }
}



extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let marginsAndInsets = layoutGuide.getInset() * CGFloat(layoutGuide.numberOfColumns()) + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + layoutGuide.getInset() * CGFloat(layoutGuide.numberOfColumns() - 1)
        
            let width = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(layoutGuide.numberOfColumns()))
            
            return CGSize(width: width, height: width)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return layoutGuide.getMinLineSpacing()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return layoutGuide.getMinInteritemSpacing()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return layoutGuide.getEdgeInsets()
    }
}
