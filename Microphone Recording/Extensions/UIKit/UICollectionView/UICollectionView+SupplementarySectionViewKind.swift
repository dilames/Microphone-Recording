//
//  UICollectionView+SupplementaryView.swift
//  Reddit
//
//  Created by Andrew Chersky on 11.11.2020.
//

import UIKit

public struct SupplementarySectionViewKind: RawRepresentable, Hashable {
    
    public static let header = SupplementarySectionViewKind(rawValue: UICollectionView.elementKindSectionHeader)
    public static let footer = SupplementarySectionViewKind(rawValue: UICollectionView.elementKindSectionFooter)
    
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
}

// swiftlint:disable force_cast
public extension UICollectionView {
    
    func registerNib<T: UIView>(withType viewType: T.Type,
                                fromBundle bundle: Bundle? = nil,
                                forSupplementaryViewOfKind kind: SupplementarySectionViewKind) {
        let reusableIdentifier = String(describing: viewType)
        let nib = UINib(nibName: reusableIdentifier, bundle: bundle)
        register(nib, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: reusableIdentifier)
    }
    
    func dequeueReusableSupplementaryView<T: UIView>(forType viewType: T.Type,
                                                     ofKind kind: SupplementarySectionViewKind,
                                                     for indexPath: IndexPath) -> T {
        let reusableIdentifier = String(describing: viewType)
        return dequeueReusableSupplementaryView(ofKind: kind.rawValue,
                                                withReuseIdentifier: reusableIdentifier,
                                                for: indexPath) as! T
    }
    
}
// swiftlint:enable force_cast
