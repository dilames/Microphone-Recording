//
//  ActionButton.swift
//  Fortu Wealth
//
//  Created by Andrew Chersky on 25.01.2021.
//

import UIKit

class ActionButton: UIButton {
    
    @IBInspectable var pressedBackgroundColor: UIColor = UIColor.red
    @IBInspectable var regularBackgroundColor: UIColor = UIColor.blue
    @IBInspectable var disabledBackgroundColor: UIColor = UIColor.black
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        adjustsImageWhenDisabled = true
        adjustsImageWhenHighlighted = true
        backgroundColor = .clear
        
        setBackgroundColor(disabledBackgroundColor, for: .disabled)
        setBackgroundColor(regularBackgroundColor, for: .normal)
        setBackgroundColor(pressedBackgroundColor, for: .highlighted)
    }
    
}

extension UIButton {
    
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }
}
