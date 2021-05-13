//
//  NSObject+assosiations.swift
//  Flawless Feedback
//
//  Created by Andrew Chersky on 3/29/19.
//  Copyright © 2019 Ahmed Sulaiman. All rights reserved.
//

import Foundation

public enum AssociationPolicy {
    
    case assign
    case retainNonatomic
    case copyNonatomic
    case retain
    case copy
    
    fileprivate var rawValue: objc_AssociationPolicy {
        switch self {
        case .assign: return .OBJC_ASSOCIATION_ASSIGN
        case .retainNonatomic: return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        case .copyNonatomic: return .OBJC_ASSOCIATION_COPY_NONATOMIC
        case .retain: return .OBJC_ASSOCIATION_RETAIN
        case .copy: return .OBJC_ASSOCIATION_COPY
        }
    }
}

public extension NSObject {
    
    func dissociate(forKey key: UnsafeRawPointer, policy: AssociationPolicy = .retain) {
        objc_setAssociatedObject(self, key, nil, policy.rawValue)
    }
    
    func associated<T>(forKey key: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(self, key) as? T
    }
    
    func associate<T>(value: T?, forKey key: UnsafeRawPointer, policy: AssociationPolicy = .retain) {
        objc_setAssociatedObject(self, key, value as AnyObject, policy.rawValue)
    }
    
    func association<T>(wrapping value: T,
                        forKey key: UnsafeRawPointer,
                        policy: AssociationPolicy = .retain) -> T? {
        if let value: T = associated(forKey: key) {
            return value
        }
        associate(value: value, forKey: key, policy: policy)
        return associated(forKey: key)
    }
}
