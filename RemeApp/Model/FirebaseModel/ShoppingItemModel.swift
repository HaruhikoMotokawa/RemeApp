//
//  ShoppingItemModel.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/06/14.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

/// 買い物リストのアイテムモデル
struct ShoppingItemModel: Codable {
    /// 買い物のID
    @DocumentID var id: String?
    /// 購入判定
    var isCheckBox: Bool = false
    /// 商品名
    var nameOfItem: String = ""
    /// 購入数
    var numberOfItem: String = ""
    /// 単位
    var unit: String = ""
    /// 売り場の番号
    var salesFloorRawValue: Int = 0
    /// 補足
    var supplement = String()
    /// 写真が保存されているCloudStorageのダウンロードURL
    var photoURL:String = ""
    /// このリストの作成者のuid
    var owner: String = ""
    /// このリストの共有者
    var sharedUsers = [String]()
    /// 作成日時
    var date = Date()
}
