//
//  CustomSalesFloorModel.swift
//  RemeApp
//
//  Created by 本川晴彦 on 2023/04/14.
//
import UIKit
import Foundation
/// 売り場の詳細データ
struct CustomSalesFloorModel {

    /// 売り場に対応するRawValue
    var customSalesFloorRawValue:Int = 0

    var customNameOfSalesFloor: String = ""
    var customColorOfSalesFloor: UIColor = .white
    /// enum SalesFloorTypeをお使いデータに登録
    var customSalesFloor: CustomSalesFloorType {
        get {
            return CustomSalesFloorType(rawValue: customSalesFloorRawValue)!
        }
        set {
            customSalesFloorRawValue = newValue.intValue
        }
    }
}
