//
//  UICollectionView+dequeueReusable.swift
//  Reddit
//
//  Created by Andrew Chersky on 11.11.2020.
//

import UIKit

public extension UICollectionView {
    
    func dequeueReusableCell<T: UICollectionViewCell>(forType cellType: T.Type, for indexPath: IndexPath) -> T {
        let reusableIdentifier = String(describing: cellType)
        // swiftlint:disable force_cast
        return dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! T
        // swiftlint:enable force_cast
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(forType cellType: T.Type, for indexPath: IndexPath) -> T where T: StaticallyReusable {
        let reusableIdentifier = cellType.reuseIdentifier
        // swiftlint:disable force_cast
        let view = dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! T
        // swiftlint:enable force_cast
        return view
    }
    
}
