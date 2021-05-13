//
//  Bundle+loadViewFromNibNamed.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 13.03.2021.
//

import UIKit

public protocol InstantiableFromBundle: AnyObject {
    static func instantiateFromNib() -> Self
}

extension UIView: InstantiableFromBundle {}

public extension InstantiableFromBundle {
    
    static func instantiateFromNib() -> Self {
        let type = Self.self
        let bundle = Bundle(for: type)
        let view = bundle.loadView(forType: type)
        return view
    }
    
}

public extension Bundle {
    
    func loadView<T>(forType type: T.Type) -> T {
        return loadView(fromNibNamed: String(describing: T.self), forType: T.self)
    }
    
    func loadView<T>(fromNibNamed fileName: String, forType type: T.Type) -> T {
        guard let view = self.loadNibNamed(fileName, owner: nil, options: nil)?.first as? T else {
            fatalError("Could not load view with type " + String(describing: type))
        }
        return view
    }
    
}
