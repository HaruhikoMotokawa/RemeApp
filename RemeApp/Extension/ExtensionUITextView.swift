//
//  ExtensionUITextView.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/10.
//

import UIKit

extension UITextView {

    /// TextViewにプレースホルダーを設置するメソッド
    func setPlaceholder() {
        self.text = "任意：３０文字以内で入力して下さい"
        self.textColor = UIColor.lightGray
    }
    /// TextViewに枠線を設置
    func setAppearance() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10.0
    }

    /// TextViewに枠線とプレースホルダーを設置
    func setAppearanceAndPlaceholder() {
        setAppearance()
        setPlaceholder()
    }
}
