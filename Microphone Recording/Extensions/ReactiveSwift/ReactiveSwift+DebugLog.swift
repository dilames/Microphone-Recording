//
//  ReactiveSwift+DebugLog.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 02.02.2021.
//

import ReactiveSwift
import os

enum StaticLoggerLevel {
    
    case `private`
    case `public`
    
    var staticRepresentation: StaticString {
        switch self {
        case .private: return StaticString("%{private}@")
        case .public: return StaticString("%{public}@")
        }
    }
    
}
