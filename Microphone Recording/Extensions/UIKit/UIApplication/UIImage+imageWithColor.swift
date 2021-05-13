//
//  UIImage+imageWithColor.swift
//  Microphone Recording
//
//  Created by Andrew Chersky on 12.03.2021.
//

import UIKit

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size)
            .image { rendererContext in
                setFill()
                rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
