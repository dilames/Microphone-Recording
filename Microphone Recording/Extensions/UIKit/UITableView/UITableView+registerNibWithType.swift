//
//  UITableView+registerNibWithType.swift
//  Reddit
//
//  Created by Andrew Chersky on 11.11.2020.
//

import UIKit

public extension UITableView {
    
    func registerNib<T: UIView>(withType viewType: T.Type, fromBundle bundle: Bundle? = nil) {
        let reusableIdentifier = String(describing: viewType)
        let reusableNib = UINib(nibName: reusableIdentifier, bundle: bundle)
        register(reusableNib, forCellReuseIdentifier: reusableIdentifier)
    }
    
    func registerHeaderFooterViewNib<T: UITableViewHeaderFooterView>(withType viewType: T.Type, fromBundle bundle: Bundle? = nil) {
        let reusableIdentifier = String(describing: viewType)
        let reusableNib = UINib(nibName: reusableIdentifier, bundle: bundle)
        register(reusableNib, forHeaderFooterViewReuseIdentifier: reusableIdentifier)
    }
    
    func registerNibs<T: UIView>(withTypes viewTypes: [T.Type], fromBundle bundle: Bundle? = nil) {
        viewTypes.forEach { registerNib(withType: $0, fromBundle: bundle) }
    }
    
}
