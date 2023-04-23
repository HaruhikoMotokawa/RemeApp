//
//  ExtensionUITextView.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/10.
//

import UIKit

extension UITextView {

    /// TextViewに枠線を設置
    func setAppearance() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10.0
    }
}
