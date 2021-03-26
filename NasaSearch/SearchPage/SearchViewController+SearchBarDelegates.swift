//
//  SearchViewController+SearchBarDelegates.swift
//  NasaSearch
//
//  Created by Lynk on 3/26/21.
//

import UIKit

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else { return }
        apiClient.fetchData(searchQuery: text) {[weak self] (result) in
            switch result {
            case let .success(entries):
                DispatchQueue.main.async {
                    self?.searchEntries = entries
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    //Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yContentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if yContentOffset > contentHeight - scrollView.frame.height {
            if !apiClient.isFetching {
                apiClient.isFetching = true
                apiClient.fetchData(searchQuery:nil) { [weak self](result) in
                    switch result {
                    case let .failure(error):
                        print(error)
                    case let .success(entries):
                        DispatchQueue.main.async {
                            self?.searchEntries.append(contentsOf: entries)
                        }
                    }
                }
            }
        }
    }
}
