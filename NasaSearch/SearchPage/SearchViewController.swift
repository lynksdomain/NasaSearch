//
//  SearchViewController.swift
//  NasaSearch
//
//  Created by Lynk on 3/25/21.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var nasaSearchBar: UISearchBar!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    let layoutGuide = CollectionLayoutGuide()
    var apiClient = NasaAPIClient()
    let imageClient = ImageClient()
    var searchEntries = [NasaEntry]() {
        didSet {
            galleryCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataSourceAndDelegate()
        setEmptyStateView()
        searchBarStyle()
    }
    
    func setDataSourceAndDelegate() {
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        nasaSearchBar.delegate = self
    }
    
    func setEmptyStateView() {
        let emptyStateView = EmptyStateView()
        galleryCollectionView.backgroundView = emptyStateView
    }
    
    func searchBarStyle() {
        nasaSearchBar.layer.borderWidth = 1
        nasaSearchBar.layer.borderColor = UIColor(red: 11/255, green: 63/255, blue: 145/255, alpha: 1).cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DetailViewController,
              let cell = sender as? GalleryCell,
              let indexPath = galleryCollectionView.indexPath(for: cell) else { return }
        let entry = searchEntries[indexPath.row]
        destination.entry = entry
    }

}
