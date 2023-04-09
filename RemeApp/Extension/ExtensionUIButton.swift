//
//  ExtensionUIButton.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/09.
//

import Foundation
import UIKit

// UIButtonに関する変更メソッド
extension UIButton {

    /// UIButtonの装飾基本設定
    /// - 文字色を黒に設定
    /// - フォントをボールドにサイズを２０に設定
    /// - 枠線の幅を１で設定
    /// - 枠線のカラーを黒に設定
    /// - バックグラウンドを角丸１０に設定
    /// - ラベルのテキストをボタンの幅に合わせて自動的に調整
    /// - ラベルの自動調整の際に縮小率を0.５に設定
    /// - ラベルの自動調整の際に必ず１行になるように設定
    func setAppearance() {
        // 文字色を黒に設定
        self.setTitleColor(.black, for: .normal)
        // フォントをボールド、サイズを２０に設定
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        // 枠線の幅を１で設定
        self.layer.borderWidth = 1
        // 枠線のカラーを黒に設定
        self.layer.borderColor = UIColor.black.cgColor
        // バックグラウンドを角丸１０に設定
        self.layer.cornerRadius = 10.0
        // ラベルのテキストをボタンの幅に合わせて自動的に調整
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        // ラベルの自動調整の際に縮小率を0.５に設定
        self.titleLabel?.minimumScaleFactor = 0.5 // 縮小率を指定する
        // ラベルの自動調整の際に必ず１行になるように設定
        self.titleLabel?.numberOfLines = 1
    }

    /// UIButtonに影をつけるメソッド
    ///- 影の色を黒に設定
    ///- 影の透明度を0.５に設定
    ///- 影のオフセット、影の位置を横２、縦２に設定
    ///- 影の半径を２に設定
    func addShadow() {
        // 影の色を黒に設定
        self.layer.shadowColor = UIColor.black.cgColor
        // 影の透明度を0.５に設定
        self.layer.shadowOpacity = 0.5
        // 影のオフセット、影の位置を横２、縦２に設定
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        // 影の半径を２に設定
        self.layer.shadowRadius = 2
    }

    /// UIButtonに基本装飾と影を設定
    /// - setAppearance(to: button)
    /// - addShadow(to: button)
    func setAppearanceWithShadow() {
        setAppearance()
        addShadow()
    }

    /// ボタンの非活性化の状態
    /// - ボタンの非活性化
    /// - バックグラウンドカラーを白に設定
    func setDisable() {
        self.isEnabled = false
        self.backgroundColor = .white
    }

    /// ボタンを活性化させる
    /// - ボタンの活性化
    /// - 背景色を灰色にする
    func setEnable() {
        self.isEnabled = true
        self.backgroundColor = .lightGray
    }
}