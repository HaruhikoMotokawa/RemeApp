//
//  ExtensionNSNotificationName.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/17.
//

import Foundation
import UIKit

// 使用マップ設定の変更に関わる通知
extension NSNotification.Name {
    // 使用する売り場マップの設定によってチェックマークを切り替える通知設定
    /// カスタムマップのチェックを表示にする
    static let showCustomSelectCheckMark = NSNotification.Name("showCustomSelectCheckMark")
    /// カスタムマップのチェックを非表示にする
    static let hideCustomSelectCheckMark = NSNotification.Name("hideCustomSelectCheckMark")
    /// デフォルトマップのチェックを表示にする
    static let showDefaultSelectCheckMark = NSNotification.Name("showDefaultSelectCheckMark")
    /// デフォルトマップのチェックを非表示にする
    static let hideDefaultSelectCheckMark = NSNotification.Name("hideDefaultSelectCheckMark")

}


// 買い物の開始位置に関わる通知
extension NSNotification.Name {
    // 買い物の開始位置の設定によってマップのカート表示を切り替える通知設定
    /// 左のカートイメージを表示し、右のカートイメージを非表示にする
    static let showLeftCartView = NSNotification.Name("showLeftCartView")
    /// 右のカートイメージを表示し、左のカートイメージを非表示にする
    static let showRightCartView = NSNotification.Name("showRightCartView")
}

// Notification.Nameの拡張
extension Notification.Name {
    static let networkStatusDidChange = Notification.Name("NetworkStatusDidChangeNotification")
}

