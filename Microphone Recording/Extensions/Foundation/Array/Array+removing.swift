//
//  Array+removing.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 03.03.2021.
//

import Foundation

extension Array {
    
    func removing(satisfying: (Element) throws -> Bool) rethrows -> Self {
        var sequence = self
        try sequence.removeAll(where: satisfying)
        return sequence
    }
    
}
