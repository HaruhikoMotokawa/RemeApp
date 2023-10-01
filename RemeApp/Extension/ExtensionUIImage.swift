//
//  ExtensionUIImage.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/03/29.
//

import UIKit

// UIImageをリサイズできるように拡張
extension UIImage {

  /// 画像の縦横サイズを指定してリサイズする、アスペクト比は無視
  func resize(to size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    defer { UIGraphicsEndImageContext() }
    draw(in: CGRect(origin: .zero, size: size))
    return UIGraphicsGetImageFromCurrentImageContext()
  }

  /// 横幅のみ指定、縦は計算して算出
  func resize(width: Double) -> UIImage? {
    // オリジナル画像のサイズからアスペクト比を計算
    let aspectScale = self.size.height / self.size.width
    // widthからアスペクト比を元にリサイズ後のサイズを取得
    let resizedSize = CGSize(width: width, height: width * Double(aspectScale))
    // リサイズ後のUIImageを生成して返却
    UIGraphicsBeginImageContext(resizedSize)
    self.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width,
                         height: resizedSize.height))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resizedImage
  }
  /// 画像自体に角丸と枠線をつける
  func roundedAndBordered() -> UIImage {
    let size = CGSize(
      width: self.size.width + 1 * 2,
      height: self.size.height + 1 * 2
    )
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { context in
      let clipPath = UIBezierPath(
        roundedRect: CGRect(
          origin: CGPoint(x: 1, y: 1),
          size: self.size
        ),
        cornerRadius: 10
      )
      UIColor.black.setStroke()
      clipPath.lineWidth = 1
      clipPath.stroke()
      clipPath.addClip()
      self.draw(at: CGPoint(x: 1, y: 1))
    }
  }
}
