//
//  EmptyStateView.swift
//  NasaSearch
//
//  Created by Lynk on 3/26/21.
//

import UIKit


class EmptyStateView: UIView {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var noSearchIcon: UIImageView!
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            Bundle.main.loadNibNamed("EmptyStateView", owner: self, options: nil)
            contentView.fixInView(self)
            noSearchIcon.image = UIImage(named: "noSearch")?.withRenderingMode(.alwaysTemplate)
        }
    }

    extension UIView
    {
        func fixInView(_ container: UIView!) -> Void{
            self.translatesAutoresizingMaskIntoConstraints = false;
            self.frame = container.frame;
            container.addSubview(self);
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
            NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        }
}
