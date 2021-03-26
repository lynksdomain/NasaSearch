//
//  DetailViewController.swift
//  NasaSearch
//
//  Created by Lynk on 3/26/21.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var entryImageView: UIImageView!
    
    @IBOutlet weak var entryTitleLabel: UILabel!
    
    @IBOutlet weak var entrySubDetailsLabel: UILabel!
    
    @IBOutlet weak var entryDescriptionTextView: UITextView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var entry: NasaEntry!
    let imageClient = ImageClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    

    func setUp() {
        guard entry.data.count > 0 else { return }
        entryTitleLabel.text = entry.data[0].title
        entryDescriptionTextView.text = entry.data[0].descriptionAvailable
        entrySubDetailsLabel.text = entry.data[0].subDetails
        activityIndicator.startAnimating()
        imageClient.getOriginalSize(urlString: entry.href) { [weak self](result) in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(image):
                DispatchQueue.main.async {
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.stopAnimating()
                    self?.entryImageView.image = image
                }
            }
        }
        
    }

}
