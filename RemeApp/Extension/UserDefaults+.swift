//
//  UserDefaults+.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/07/23.
//

import Foundation

/// 買い物開始のセグメントナンバー
enum ShoppingStartPositionType: Int {
    case left
    case right
}

/// 使用マップのセグメントナンバー
enum SalesFloorMapType: Int {
    case custom
    case `default`
}
// 拡張してキーと値を設定しておくと共通化できる、基本コンピューテッドプロパティ
extension UserDefaults {
    /// アプリインストール後初回起動フラグの保存キー
    private var isInitialLaunchKey: String { "isInitialLaunch" }
    /// アプリインストール後初回起動フラグ、保存なければデフォルトがfalse
    var isInitialLaunch: Bool {
        get {
            self.bool(forKey: isInitialLaunchKey)
        }
        set {
            self.setValue(newValue, forKey: isInitialLaunchKey)
        }
    }
    /// 導入スクショ閲覧フラグの保存キー
    private var isIntroductionSeenKey: String { "isIntroductionSeen" }
    /// 導入スクショ閲覧フラグ、保存なければデフォルトがfalse
    var isIntroductionSeen: Bool {
        get {
            self.bool(forKey: isIntroductionSeenKey)
        }
        set {
            self.setValue(newValue, forKey: isIntroductionSeenKey)
        }
    }
    /// 使用マップの保存キー
    private var useSalesFloorTypeKey: String { "useSalesFloorTypeKey" }
    /// 使用マップのセグメントナンバー、保存がなければデフォルトが0
    var useSalesFloorType: Int {
        get {
            self.integer(forKey: useSalesFloorTypeKey)
        }
        set {
            self.setValue(newValue, forKey: useSalesFloorTypeKey)
        }
    }
    /// 買い物開始位置の保存キー
    private var shoppingStartPositionKey:String  { "shoppingStartPositionKey" }
    /// 買い物開始位置のセグメントナンバー、保存がなければデフォルトが0
    var shoppingStartPosition: Int {
        get {
            self.integer(forKey: shoppingStartPositionKey)
        }
        set {
            self.setValue(newValue, forKey: shoppingStartPositionKey)
        }
    }
}
