//
//  ExtensionUIImage.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/29.
//

import UIKit

// UIImageをリサイズできるように拡張
extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func roundedAndBordered(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) -> UIImage? {
        let size = CGSize(width: self.size.width + borderWidth * 2, height: self.size.height + borderWidth * 2)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let clipPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: borderWidth, y: borderWidth), size: self.size), cornerRadius: cornerRadius)
            borderColor.setStroke()
            clipPath.lineWidth = borderWidth
            clipPath.stroke()
            clipPath.addClip()
            self.draw(at: CGPoint(x: borderWidth, y: borderWidth))
        }
    }
}
