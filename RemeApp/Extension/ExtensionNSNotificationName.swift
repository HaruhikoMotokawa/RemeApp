//
//  ExtensionNSNotificationName.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/17.
//

import Foundation
import UIKit

// 使用する売り場の設定によってチェックマークを切り替える通知設定
extension NSNotification.Name {
    static let showCustomSelectCheckMark = NSNotification.Name("showCustomSelectCheckMark")
    static let hideCustomSelectCheckMark = NSNotification.Name("hideCustomSelectCheckMark")
    static let showDefaultSelectCheckMark = NSNotification.Name("showDefaultSelectCheckMark")
    static let hideDefaultSelectCheckMark = NSNotification.Name("hideDefaultSelectCheckMark")
}

// 買い物の開始位置の設定によってチェックマークを切り替える通知設定
extension NSNotification.Name {
    static let showLeftCartView = NSNotification.Name("showLeftCartView")
    static let showRightCartView = NSNotification.Name("showRightCartView")
}

// 買い物の開始位置の設定によって買い物リストの並順を切り替える通知設定
extension NSNotification.Name {
    static let sortLeftErrandDataList = NSNotification.Name("sortLeftErrandDataList")
    static let sortRightErrandDataList = NSNotification.Name("sortRightErrandDataList")
}
