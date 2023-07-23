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


extension UserDefaults {
    /// 使用マップの保存キー
    private var useSalesFloorTypeKey: String { "useSalesFloorTypeKey" }

    /// 使用マップのセグメントナンバーを保存
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

    /// 買い物開始位置のセグメントナンバー
    var shoppingStartPosition: Int {
        get {
            self.integer(forKey: shoppingStartPositionKey)
        }
        set {
            self.setValue(newValue, forKey: shoppingStartPositionKey)
        }
    }

}
