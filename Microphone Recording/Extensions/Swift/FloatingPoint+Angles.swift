//
//  FloatingPoint+Angles.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 05.02.2021.
//

import Foundation

extension FloatingPoint {
    var asRadians: Self { self * .pi / 180 }
    var asDegrees: Self { self * 180 / .pi }
}
