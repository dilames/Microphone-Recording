//
//  String+RegularExpressions.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 15.04.2021.
//

import Foundation

public extension String {
    
    func firstMatch(withPattern pattern: String) -> String? {
        
        guard let expression = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        
        let stringRange = NSRange(self.startIndex..., in: self)
        
        return expression
            .firstMatch(in: self, options: [], range: stringRange)
            .map { self.substring(with: $0.range) }
    }
    
    func matches(_ pattern: String) -> Bool {
        
        guard let expression = try? NSRegularExpression(pattern: pattern, options: []) else {
            return false
        }
        
        let stringRange = NSRange(self.startIndex..., in: self)
        let matchRange = expression.rangeOfFirstMatch(in: self, options: [], range: stringRange)
        
        return stringRange == matchRange
    }
    
    func contains(pattern: String) -> Bool {
        
        guard let expression = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        
        let stringRange = NSRange(self.startIndex..., in: self)
        
        return expression.firstMatch(in: self, options: [], range: stringRange) != nil
    }
    
    func substring(with range: NSRange) -> String {
        return NSString(string: self).substring(with: range)
    }
}
