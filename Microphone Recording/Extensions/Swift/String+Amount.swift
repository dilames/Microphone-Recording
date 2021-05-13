//
//  String+Amount.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 15.04.2021.
//

import UIKit

public extension String {
    
    static var currencySeparator: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = Locale(identifier: "en_GB")
        currencyFormatter.numberStyle = .decimal
        return currencyFormatter.decimalSeparator
    }
    
    func attributedAmountString(font: UIFont, smallFractionPart: Bool) -> NSMutableAttributedString {

        let components = self.components(separatedBy: String.currencySeparator)
        let attributedString = NSMutableAttributedString(string: self)

        //set fraction part smaller
        let rangeFractionPart = NSRange(location: components.first!.count + 1, length: 2)
        let attributeFractionPart = smallFractionPart
            ? [NSAttributedString.Key.font: UIFont(name: font.fontName, size: font.pointSize - (font.pointSize * 0.21))!]
            : [NSAttributedString.Key.font: UIFont(name: font.fontName, size: font.pointSize)!]

        //set integer part and currency symbol to correct font
        let rangeIntegerPart = NSRange(location: 0, length: components.first!.count)
        let attributeIntegerPart = [NSAttributedString.Key.font: UIFont(name: font.fontName, size: font.pointSize)!]

        let rangeCurrencySymbol = NSRange(location: self.count - 1, length: 1)
        let attributeCurrencySymbol = [NSAttributedString.Key.font: UIFont(name: font.fontName, size: font.pointSize)!]

        attributedString.addAttributes(attributeFractionPart, range: rangeFractionPart)
        attributedString.addAttributes(attributeIntegerPart, range: rangeIntegerPart)
        attributedString.addAttributes(attributeCurrencySymbol, range: rangeCurrencySymbol)
        return attributedString
    }
}
