//
//  DispatchTimeInterval.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 06.02.2021.
//

import Foundation

extension DispatchTimeInterval {
    
    var timeInterval: TimeInterval {
        switch self {
        case .seconds(let value): return Double(value)
        case .milliseconds(let value): return Double(value) * 0.001
        case .microseconds(let value): return Double(value) * 0.000001
        case .nanoseconds(let value): return Double(value) * 0.000000001
        case .never: return 0
        @unknown default: return 0
        }
    }
    
}
