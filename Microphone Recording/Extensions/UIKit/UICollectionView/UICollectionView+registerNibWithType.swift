//
//  UICollectionView+registerNibWithType.swift
//  Reddit
//
//  Created by Andrew Chersky on 11.11.2020.
//

import UIKit

public protocol StaticallyReusable {
    static var reuseIdentifier: String { get }
}

/**
 Default reuse identifier is conforming class name.
 **/

public extension StaticallyReusable {
    static var reuseIdentifier: String { return String(describing: self) }
}

public extension UICollectionView {
    
    func register<T: UIView & StaticallyReusable>(withType viewType: T.Type, fromBundle bundle: Bundle? = nil) {
        register(viewType, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func registerNib<T: UIView>(withType viewType: T.Type, fromBundle bundle: Bundle? = nil) {
        let reusableIdentifier = String(describing: viewType)
        let reusableNib = UINib(nibName: reusableIdentifier, bundle: bundle)
        register(reusableNib, forCellWithReuseIdentifier: reusableIdentifier)
    }
    
    func registerNibs<T: UIView>(withTypes viewTypes: [T.Type], fromBundle bundle: Bundle? = nil) {
        viewTypes.forEach { registerNib(withType: $0, fromBundle: bundle) }
    }
    
}
