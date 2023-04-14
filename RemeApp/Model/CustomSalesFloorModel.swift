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

enum CustomSalesFloorType: Int, CaseIterable { // Realm実装時に追記-> , PersistableEnum

    /// 売り場の番地、赤１〜５と青１〜７、緑１〜５
    case redOne
    case redTwo
    case redThree
    case redFour
    case redFive
    case blueOne
    case blueTwo
    case blueThree
    case blueFour
    case blueFive
    case blueSix
    case blueSeven
    case greenOne
    case greenTwo
    case greenThree
    case greenFour
    case greenFive

    /// enumにintValueを設定
    var intValue: Int {
        return self.rawValue
    }

    /// intValueからenumを設定する
    init?(intValue: Int) {
        self.init(rawValue: intValue)

    }
}
