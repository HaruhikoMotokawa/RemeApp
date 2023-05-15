//
//  CustomSalesFloorModel.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/14.
//
import RealmSwift
import UIKit
import Foundation
/// 売り場の詳細データ
class CustomSalesFloorModel: Object {
    
    /// データのID
    @objc dynamic var id:String = UUID().uuidString
    /// 売り場に対応するRawValue
    @objc dynamic var customSalesFloorRawValue:Int = 0
    /// 売り場の名称
    @objc dynamic var customNameOfSalesFloor: String = "未設定"
    /// 売り場の色
    @objc dynamic var customColorOfSalesFloorRawValue:Int = 0
    /// enum CustomSalesFloorTypeをお使いデータに登録
    var customSalesFloorType: CustomSalesFloorType {
        get {
            return CustomSalesFloorType(rawValue: customSalesFloorRawValue)!
        }
        set {
            customSalesFloorRawValue = newValue.intValue
        }
    }

    var customSalesFloorColor: CustomSalesFloorColor {
        get {
            return CustomSalesFloorColor(rawValue: customColorOfSalesFloorRawValue)!
        }
        set {
            customColorOfSalesFloorRawValue = newValue.intValue
        }
    }

    override static func primaryKey() -> String? {
        return "id"
    }

    // CustomSalesFloorModelの初期化メソッド
    convenience init(salesFloorRawValue: Int, nameOfSalesFloor: String, customColorOfSalesFloorRawValue: Int) {
        self.init()
        self.customSalesFloorRawValue = salesFloorRawValue
        self.customNameOfSalesFloor = nameOfSalesFloor
        self.customColorOfSalesFloorRawValue = customColorOfSalesFloorRawValue
    }
}
