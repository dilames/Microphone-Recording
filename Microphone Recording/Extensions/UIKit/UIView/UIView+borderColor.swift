//
//  UIView+borderColor.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 19.04.2021.
//

import UIKit

extension UIView {
    
    @IBInspectable
    var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor }
        get { return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : nil }
    }
    
}
