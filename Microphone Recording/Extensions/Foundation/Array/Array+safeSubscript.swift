//
//  Array+SafeSubscript.swift
//  Flawless Feedback
//
//  Created by Andrew Chersky on 5/23/19.
//  Copyright © 2019 Ahmed Sulaiman. All rights reserved.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        guard index < count, index >= 0 else { return nil }
        return self[index]
    }
}
