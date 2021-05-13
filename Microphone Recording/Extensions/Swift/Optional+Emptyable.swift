//
//  Optional.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 15.04.2021.
//

import UIKit

public protocol Emptyable {
    static var empty: Self { get }
}

extension String: Emptyable {
    public static var empty: String {
        return ""
    }
}

extension Int: Emptyable {
    public static var empty: Int {
        return 0
    }
}

extension Double: Emptyable {
    public static var empty: Double {
        return 0.0
    }
}

extension Float: Emptyable {
    public static var empty: Float {
        return 0.0
    }
}

extension CGFloat: Emptyable {
    public static var empty: CGFloat {
        return 0.0
    }
}

extension Array: Emptyable {
    public static var empty: [Element] {
        return []
    }
}

extension Dictionary: Emptyable {
    public static var empty: [Key: Value] {
        return [:]
    }
}

public extension Optional where Wrapped: Emptyable {
    
    func safelyUnwrapped(_ empty: Wrapped = Wrapped.empty) -> Wrapped {
        switch self {
        case .some(let unwrapped):
            return unwrapped
        case .none:
            return empty
        }
    }
}

public extension Optional {
    
    func safelyUnwrapped(_ empty: Wrapped) -> Wrapped {
        switch self {
        case .some(let unwrapped):
            return unwrapped
        case .none:
            return empty
        }
    }
}

public extension Optional {
    
    func emptyMap<T: Emptyable>(empty: T = T.empty, _ transform: (Wrapped) -> T) -> T {
        switch self {
        case .some(let unwrapped):
            return transform(unwrapped)
        case .none:
            return T.empty
        }
    }
}

public extension Optional where Wrapped: Error {
    
    func `throw`() throws {
        switch self {
        case .some(let error):
            throw error
        case .none:
            break
        }
    }
}

public extension Optional where Wrapped == String {
    
    var isEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
