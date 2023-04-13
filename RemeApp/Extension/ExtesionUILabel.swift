//
//  ExtesionUILabel.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/09.
//

import UIKit

extension UILabel {

    /// UILabelに枠線を設定するメソッド
    /// - 枠線の色を黒に設定
    /// - 枠線の太さを２に設定
    /// - 枠線を角丸に設定
    /// - サイズを枠線に合わせる
    func setBorder() {
        let borderColor = UIColor.black.cgColor
        self.layer.borderColor = borderColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        self.sizeToFit()
    }
}
